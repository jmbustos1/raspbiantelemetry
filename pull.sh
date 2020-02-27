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
    echo "appy changes..."

    pip3 install -r requirements.txt

    ./copyConf.sh etc usr

    # CAN
    sed -i '/###############CAN ENABLED#############/,/############CAN ENABLED END############/d' /boot/config.txt
    cat ${WORKING_DIR}/boot/config.txt >> /boot/config.txt

    cat ${WORKING_DIR}/crontab.user| crontab -
    cat ${WORKING_DIR}/crontab.root| sudo su -c "crontab -"

    sudo service networking restart
    sudo service gpsd restart
    sudo service supervisor restart
  fi
fi
