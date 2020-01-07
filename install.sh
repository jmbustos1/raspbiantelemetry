#!/bin/bash

# sim7600
aptitude install libqmi-utils udhcpc gpsd supervisor

while [ $(ls /dev/cdc-wdm* 2> /dev/null| wc -l) = 0 ]
do
  echo "waiting for /dev/cdc-wdm* ..."
  sleep 1
done

devwwan0="$(ls /dev/cdc-wdm*| tail -n 1| awk '{print $1}')"

qmicli -p -d ${devwwan0} --wds-modify-profile="3gpp,1,pdp-type=IPV4"
qmicli -p -d ${devwwan0} --wds-set-ip-family=4
qmicli -p -d ${devwwan0} --wds-set-default-profile-num="3gpp,1"
qmicli -p -d ${devwwan0} --wds-delete-profile="3gpp2,1"
qmicli -p -d ${devwwan0} --wds-set-autoconnect-settings=disabled

cp usr/bin/check7600 /usr/bin/check7600
cat crontab.root | crontab -

# CAN
cat boot/config.txt >> /boot/config.txt
cp can0 /etc/network/interfaces.d/can0
mkdir -p No_Enviados
mkdir -p Enviados

# python
aptitude install virtualenv

su - pi -c '
virtualenv -p python3 env3
source env3/bin/activate
pip3 install --upgrade pip
pip3 install -r raspbiantelemetry/requirements.txt
deactivate
'
