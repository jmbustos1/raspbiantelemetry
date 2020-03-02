#!/bin/bash

WORKING_DIR="$(dirname $(readlink -f ${0}))"
ACTIVATE_PATH="$(dirname ${WORKING_DIR})/env3/bin/activate"

cd ${WORKING_DIR}

git remote update
if [ $(git status -uno| grep 'origin/master'| grep -v 'up to date'| wc -l) -ge 1 ]
then
  git pull > pull.log 2>&1

  if [ $(cat pull.log|grep "Already up-to-date."|wc -l) -ne 1 ] &&
     [ $(cat pull.log|grep "Ya está actualizado."|wc -l) -ne 1 ] &&
     [ $(cat pull.log|grep "Name or service not known"|wc -l) -ne 1 ]
  then
    echo "appy changes..."

    # python requirements
    ${WORKING_DIR}/run.sh pip3 install -r ${WORKING_DIR}/requirements.txt

    # copy files
    sudo ${WORKING_DIR}/copyConf.sh etc usr

    # copy CAN config
    sudo sed -i '/###############CAN ENABLED#############/,/############CAN ENABLED END############/d' /boot/config.txt
    cat ${WORKING_DIR}/boot/config.txt| sudo tee -a /boot/config.txt"

    # crontabs
    cat ${WORKING_DIR}/crontab.user| crontab -
    cat ${WORKING_DIR}/crontab.root| sudo su -c "crontab -"

    # restart services
    sudo service networking restart
    sudo service gpsd restart
    sudo service supervisor restart
  fi
fi
