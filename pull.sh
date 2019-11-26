#!/bin/bash

WORKING_DIR="$(dirname $(readlink -f ${0}))"
ACTIVATE_PATH="$(dirname ${WORKING_DIR})/env3/bin/activate"

cd ${WORKING_DIR}
source ${ACTIVATE_PATH}

git pull > pull.log 2>&1

if [ $(cat pull.log|grep "Already up-to-date."|wc -l) -ne 1 ] &&
   [ $(cat pull.log|grep "Ya está actualizado."|wc -l) -ne 1 ] &&
   [ $(cat pull.log|grep "Name or service not known"|wc -l) -ne 1 ]
then
  pip3 install -r requirements.txt
  sudo cp cancollecter.conf /etc/supervisor/conf.d/cancollecter.conf
  sudo cp push2aws.conf /etc/supervisor/conf.d/push2aws.conf
  sudo service supervisor restart
fi
