#!/bin/bash

WORKING_DIR="$(dirname $(readlink -f ${0}))"
ACTIVATE_PATH="$(dirname ${WORKING_DIR})/env3/bin/activate"

cd ${WORKING_DIR}
source ${ACTIVATE_PATH}

if [ ! -f ${WORKING_DIR}/reboot02.log ]
then
  touch ${WORKING_DIR}/reboot02.log
  echo "reboteado" > ${WORKING_DIR}/reboot02.log
  rm ${WORKING_DIR}/reboot01.log
  rm -rf ${WORKING_DIR}/No_Enviados/*
  sudo reboot
fi

git remote update
if [ $(git status -uno| grep 'origin/master'| grep -v 'up to date'| wc -l) -ge 1 ]
then
  git pull > pull.log 2>&1

  if [ $(cat pull.log|grep "Already up-to-date."|wc -l) -ne 1 ] &&
     [ $(cat pull.log|grep "Ya está actualizado."|wc -l) -ne 1 ] &&
     [ $(cat pull.log|grep "Name or service not known"|wc -l) -ne 1 ]
  then
    cat ${WORKING_DIR}/crontab.user| crontab -

    sudo cp ${WORKING_DIR}/etc/qmi-network.conf /etc/qmi-network.conf
    sudo cp ${WORKING_DIR}/usr/bin/check7600 /usr/bin/check7600
    sudo cat ${WORKING_DIR}/crontab.root| crontab -

    sudo cp ${WORKING_DIR}/etc/network/interfaces.d/can0 /etc/network/interfaces.d/can0
    sudo service networking restart

    sudo cp ${WORKING_DIR}/etc/default/gpsd /etc/default/gpsd
    sudo service gpsd restart

    pip3 install -r requirements.txt
    sudo cp cancollecter.conf /etc/supervisor/conf.d/cancollecter.conf
    sudo cp push2aws.conf /etc/supervisor/conf.d/push2aws.conf
    sudo service supervisor restart
  fi
fi
