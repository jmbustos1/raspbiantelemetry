import datetime
import time
import can
import time
import os
import asyncio
import random
import glob
from gps3 import gps3

test = '/home/pi/raspbiantelemetry/Enviados/*'
r = glob.glob(test)
for i in r:
        os.remove(i)
###COMMIT DE REINICIO
####iniciar CANbus #####
try:
        print('\n\rCAN Rx test')
        print('Bring up CAN0....')
        os.system("sudo /sbin/ip link set can0 up type can bitrate 500000")
        time.sleep(0.1)
except OSError:
	print('Cannot find PiCAN board.')
	exit()

####Directorios####
open_path = '/home/pi/raspbiantelemetry/boot.txt'
path = '/home/pi/raspbiantelemetry/No_Enviados/'

SOC_id = '10ffecf4'
RPM_id = '18ff459a'
final_SOC = 0
final_RPM = 0
final_i_bat = 0
final_v_bat = 0

Data_collected = '0 0 0 0'
GPS_data  = '0 0 0'

####Definir CAN
try:
	bus = can.interface.Bus(channel='can0', bustype='socketcan_native')
	print('PiCAN Board Found')
except OSError:
	print('Cannot find PiCAN board.')
	exit()


####Definir GPS
try:
        gps_socket = gps3.GPSDSocket()
        data_stream = gps3.DataStream()
        gps_socket.connect()
        gps_socket.watch()
        print('GPS FOUND')
	
except OSError:
	print('noGPS Found')
	pass


print('Ready')

######Interfaz grafica
async def busRecv():
        loop = asyncio.get_event_loop()
        return await loop.run_in_executor(None, bus.recv)



async def GPS_f():
        global GPS_data
        for new_data in gps_socket:
                if new_data:
                        data_stream.unpack(new_data)
                        #print('Altitude = ', data_stream.TPV['alt'])
                        #print('Latitude = ', data_stream.TPV['lat'])
                        #print('Longitude = ', data_stream.TPV['lon'])
                        GPS_data  = str(data_stream.TPV['alt']) + ' ' + str(data_stream.TPV['lat']) + ' ' + str(data_stream.TPV['lon']) 
                        print(GPS_data)
                await asyncio.sleep(1)
                        
async def collector():
        global SOC_id
        global RPM_id
        global Data_collected
        global final_SOC
        global final_RPM
        global final_i_bat
        global final_v_bat
        #####In the loop
        try:
             while True:
                now = datetime.datetime.now()
                message = await busRecv()
                Data_collected = message
                
                c = '{0:f} {1:x} {2:x} '.format(message.timestamp, message.arbitration_id, message.dlc)
                s=''
                soc=''
                rpm=''
                i_bat=''
                v_bat=''
                
                if message.arbitration_id == int(SOC_id,16):
                        for i in range(message.dlc):
                            s += '{0:x} '.format(message.data[i])
                        #print(' {}'.format(c+s))
                        Total = ' {}'.format(c+s)
                        
                        soc = '{0:x} '.format(message.data[5]) + '{0:x} '.format(message.data[4])
                        soc = int(soc.replace(' ',''),16)
                        final_SOC = (soc & 1023)*0.1
                        
                if message.arbitration_id == int(RPM_id,16):
                        for i in range(message.dlc):
                            s += '{0:x} '.format(message.data[i])
                        #print(' {}'.format(c+s))
                        Total = ' {}'.format(c+s)
                        
                        rpm = '{0:x} '.format(message.data[5]) + '{0:x} '.format(message.data[4])
                        #print(rpm)
                        rpm = int(rpm.replace(' ',''),16) - 15000
                        final_RPM = rpm
                        
                if message.arbitration_id == int(SOC_id,16):
                        for i in range(message.dlc):
                            s += '{0:x} '.format(message.data[i])
                        #print(' {}'.format(c+s))
                        Total = ' {}'.format(c+s)
                        
                        i_bat = '{0:x} '.format(message.data[3]) + '{0:x} '.format(message.data[2])
                        i_bat = int(i_bat.replace(' ',''),16)
                        final_i_bat = (i_bat & 16343)*0.1 - 600
                        
                if message.arbitration_id == int(SOC_id,16):
                        
                        for i in range(message.dlc):
                            s += '{0:x} '.format(message.data[i])
                        #print(' {}'.format(c+s))
                        Total = ' {}'.format(c+s)
                        
                        v_bat = '{0:x} '.format(message.data[1]) + '{0:x} '.format(message.data[0])
                        v_bat = int(v_bat.replace(' ',''),16)
                        final_v_bat = (v_bat & 8191)*0.1
                        
                Data_collected = str(final_SOC) + ' ' + str(final_RPM) + ' ' + str(final_i_bat) + ' ' + str(final_v_bat)
                await asyncio.sleep(0)

        except KeyboardInterrupt:
            os.system("sudo /sbin/ip link set can0 down")
            print('\n\rKeyboard interrupt')

        await asyncio.sleep(0)

async def printData():
        global Data_collected
        global GPS_data
        while True:
                soc = ''
                #####Interfaz   tkinter
                now = datetime.datetime.now()
                TO_SEND = Data_collected + ' ' + GPS_data
                f=open(path + str(now) + '.txt','a')
                f.write(str(now) + ' ' + TO_SEND)
                f.close()

                put = str(now) + ' ' + TO_SEND
                #print(Data_collected)
                #print(GPS_data)
                print(TO_SEND)
                await asyncio.sleep(10)


async def main():
        jobs = [collector(), printData()]
        await asyncio.gather(*jobs)


loop = asyncio.get_event_loop()
loop.run_until_complete(asyncio.gather(printData(),collector(),GPS_f()))
loop.close()
