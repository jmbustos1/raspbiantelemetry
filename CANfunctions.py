# -*- coding: utf-8 -*-
"""
Created on Wed Feb  5 14:52:53 2020

@author: tecob
"""

def ReadSoc(S, C, M_data, M_dlc, SOC):
    
    for i in range(M_dlc):
        S += '{0:x} '.format(M_data[i])
        #print(' {}'.format(c+s))
        Total = ' {}'.format(C+S)
                        
        SOC = '{0:x} '.format(M_data[5]) + '{0:x} '.format(M_data[4])
        SOC = int(SOC.replace(' ',''),16)
        final_SOC = (SOC & 1023)*0.1
        return final_SOC
    
def ReadRPM(S, C, M_data, M_dlc, RPM):
    
    for i in range(M_dlc):
        S += '{0:x} '.format(M_data[i])
        #print(' {}'.format(c+s))
        Total = ' {}'.format(C+S)
                        
        RPM = '{0:x} '.format(M_data[5]) + '{0:x} '.format(M_data[4])
        #print(rpm)
        RPM = int(RPM.replace(' ',''),16) - 15000
        final_RPM = RPM
        return final_RPM
    
def ReadIbat(S, C, M_data, M_dlc, IBAT):
    
    for i in range(M_dlc):
        S += '{0:x} '.format(M_data[i])
        #print(' {}'.format(c+s))
        Total = ' {}'.format(C+S)
                        
        IBAT = '{0:x} '.format(M_data[3]) + '{0:x} '.format(M_data[2])
        IBAT = int(IBAT.replace(' ',''),16)
        final_i_bat = (IBAT & 16343)*0.1 - 600
        return final_i_bat
    
def ReadVbat(S, C, M_data, M_dlc, VBAT):
    
    for i in range(M_dlc):
        S += '{0:x} '.format(M_data[i])
        #print(' {}'.format(c+s))
        Total = ' {}'.format(C+S)
                        
        VBAT = '{0:x} '.format(M_data[1]) + '{0:x} '.format(M_data[0])
        VBAT = int(VBAT.replace(' ',''),16)
        final_v_bat = (VBAT & 8191)*0.1
        return final_v_bat
    
def TTest(F):
    R = F + 5
    return R
    
    
    
    
    
    
    
    