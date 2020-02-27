#!/bin/bash

WORKING_DIR="$(dirname $(readlink -f ${0}))"

# packages
apt install -y aptitude

# packages python
aptitude install virtualenv supervisor
# packages sim (GSM and GPS)
aptitude install libqmi-utils udhcpc gpsd

# copy files
./copyConf.sh etc usr

# copy CAN config
sed -i '/###############CAN ENABLED#############/,/############CAN ENABLED END############/d' /boot/config.txt
cat ${WORKING_DIR}/boot/config.txt >> /boot/config.txt

# GSM
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

cat ${WORKING_DIR}/crontab.root| crontab -
su - pi -c "cat ${WORKING_DIR}/crontab.user| crontab -"

# GPS
service gpsd restart

# python
su - pi -c "
virtualenv -p python3 env3
source env3/bin/activate
pip3 install --upgrade pip
pip3 install -r ${WORKING_DIR}/requirements.txt
"

mkdir -p ${WORKING_DIR}/No_Enviados
mkdir -p ${WORKING_DIR}/Enviados

service supervisor restart
