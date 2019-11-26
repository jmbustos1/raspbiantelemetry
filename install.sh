#!/bin/bash

# sim7600
aptitude install libqmi-utils udhcpc gpsd

qmicli -p -d /dev/cdc-wdm0 --wds-modify-profile="3gpp,1,pdp-type=IPV4"
qmicli -p -d /dev/cdc-wdm0 --wds-modify-profile="3gpp2,1,pdp-type=IPV4"
qmicli -p -d /dev/cdc-wdm0 --wds-delete-profile="3gpp2,1"
qmicli -p -d /dev/cdc-wdm0 --wds-set-default-profile-num="3gpp,1"
# qmicli -p -d /dev/cdc-wdm0 --wds-set-default-profile-num="3gpp2,1"
qmicli -p -d /dev/cdc-wdm0 --wds-set-autoconnect-settings=enabled
qmicli -p -d /dev/cdc-wdm0 --wds-set-ip-family=4

cp etc/systemd/system/set7600.service /etc/systemd/system/set7600.service
cp usr/bin/set7600 /usr/bin/set7600
systemctl enable set7600

cp usr/bin/check7600 /usr/bin/check7600
cat crontab.root | crontab -

# CAN
cat boot/config.txt >> /boot/config.txt
cp etc/systemd/system/setMCP2515.service /etc/systemd/system/setMCP2515.service
cp usr/bin/setMCP2515 /usr/bin/setMCP2515
systemctl enable setMCP2515

# python
aptitude install virtualenv

su - pi -c '
virtualenv -p python3 env3
source env3/bin/activate
pip3 install --upgrade pip
pip3 install -r requirements.txt
deactivate
'
