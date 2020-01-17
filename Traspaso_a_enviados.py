#linea de prueba
from AWSIoTPythonSDK.MQTTLib import AWSIoTMQTTShadowClient
from AWSIoTPythonSDK.MQTTLib import AWSIoTMQTTClient
import AWSIoTPythonSDK
import time
import numpy as np
import json
import os
import shutil
###reinicio.py
# A random programmatic shadow client ID.
SHADOW_CLIENT = "myShadowClient"

# The unique hostname that AWS IoT generated for
# this device.
HOST_NAME = "a3j11b88qfh3w4-ats.iot.us-east-1.amazonaws.com"

# The relative path to the correct root CA file for AWS IoT,
# that you have already saved onto this device.
ROOT_CA = "C:\Users\tecob\OneDrive\Documents\raspbiantelemetry\AmazonRootCA1.pem.txt"

# The relative path to your private key file that
# AWS IoT generated for this device, that you
# have already saved onto this device.
PRIVATE_KEY = "C:\Users\tecob\OneDrive\Documents\raspbiantelemetry\56f4000c82-private.pem.key"

# The relative path to your certificate file that
# AWS IoT generated for this device, that you
# have already saved onto this device.
CERT_FILE = "C:\Users\tecob\OneDrive\Documents\raspbiantelemetry\56f4000c82-certificate.pem.crt"

# A programmatic shadow handler name prefix.
SHADOW_HANDLER = "rpi1"

# Automatically called whenever the shadow is updated.
def myShadowUpdateCallback(payload, responseStatus, token):
    print()
    print('UPDATE: $aws/things/' + SHADOW_HANDLER +
    '/shadow/update/#')
    print("payload = " + payload)
    print("responseStatus = " + responseStatus)
    print("token = " + token)
#myAWSIoTMQTTClient = None
# Create, configure, and connect a shadow client.

isConnected = False
while not isConnected:
    try:
        myAWSIoTMQTTClient = AWSIoTMQTTClient(SHADOW_HANDLER)
        myAWSIoTMQTTClient.configureEndpoint(HOST_NAME, 8883)
        myAWSIoTMQTTClient.configureCredentials(ROOT_CA, PRIVATE_KEY, CERT_FILE)

        #myAWSIoTMQTTClient.configureOfflinePublishQueueing(-1)
        myAWSIoTMQTTClient.configureDrainingFrequency(2)
        myAWSIoTMQTTClient.configureConnectDisconnectTimeout(10)
        myAWSIoTMQTTClient.configureMQTTOperationTimeout(5)
        myAWSIoTMQTTClient.connect()
        isConnected = True
    except Exception:
        time.sleep(10)
        isConnected = False

# Create a programmatic representation of the shadow.
topic = '$aws/rules/CANupdate'

open_path = '/home/pi/raspbiantelemetry/boot.txt'
path = '/home/pi/raspbiantelemetry/No_Enviados/'
to_path = '/home/pi/raspbiantelemetry/Enviados'
all_files = os.listdir(path)

f=open(open_path,'a')
title = 'Days of the Week'
f.write(title + "\n")
f.close()

while True:
    all_files = os.listdir(path)

    all_files = os.chdir(path)
    all_files = sorted(filter(os.path.isfile, os.listdir('.')), key=os.path.getmtime)
    if len(all_files)>0:
        print(all_files)
        ran = np.random.randint(10)
        ran2 = np.random.randint(100)

        f=open(path + str(all_files[0]) ,'r')


        data = f.read().split()
        try:
            x_2= {
                "fecha" : str(data[0]),
                "hora" : str(data[1]),
                "SOC": data[2],
                "RPM": data[3],
                "Corriente Bateria": data[4],
                "Voltaje Bateria": data[5],
                "Altitud": data[6],
                "Latitud": data[7],
                "Longitud": data[8]
                }
        except:
            x_2= {
                "fecha" : str(0),
                "hora" : str(0),
                "SOC": str(0),
                "RPM": str(0),
                "Corriente Bateria": str(0),
                "Voltaje Bateria": str(0),
                "Altitud": str(0),
                "Latitud": str(0),
                "Longitud": str(0)
                }
        x_2 = json.dumps(x_2)

        To_send2 = '{"state":"okay"}'
        isPublished = False
        while not isPublished:
            try:
                myAWSIoTMQTTClient.publish(topic, x_2, 1)
                isPublished = True
            except Exception:
                time.sleep(2)
                isPublished = False
        print(str(x_2) + ' ' + 'sent')
        shutil.copy(path + str(all_files[0]), to_path)
        os.remove(path + str(all_files[0]))
        print('ok')
        # Wait for this test value to be added.
    time.sleep(10)

