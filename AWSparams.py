# -*- coding: utf-8 -*-
"""
Created on Tue Feb  4 15:58:39 2020

@author: tecob
"""
Credentials = {
	"SHADOW_CLIENT" : "myShadowClient",
	"HOST_NAME" : "a3j11b88qfh3w4-ats.iot.us-east-1.amazonaws.com",
	"ROOT_CA" : "/home/pi/raspbiantelemetry/AmazonRootCA1.pem.txt",
	"PRIVATE_KEY" : "/home/pi/raspbiantelemetry/56f4000c82-private.pem.key",
	"CERT_FILE" : "/home/pi/raspbiantelemetry/56f4000c82-certificate.pem.crt",
	"SHADOW_HANDLER" : "rpi1"
}


MQTTClient = {
	"DrainingFrequency" : 2,
	"ConnectDisconnectTimeout" : 10,
	"MQTTOperationTimeout" : 5,
	"MQTTConnectExceptionTime" : 10,
    "MQTTPublishExceptionTime" : 2,
    "MQTTPublishQuality" : 1,
    "MQTTPublishTime" : 0.5
}


Paths = {
        "topic" : '$aws/rules/CANupdate',
        "open_path" : '/home/pi/raspbiantelemetry/boot.txt',
        "path" : '/home/pi/raspbiantelemetry/No_Enviados/',
        "to_path" : '/home/pi/raspbiantelemetry/Enviados'
}

