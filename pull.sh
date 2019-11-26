#!/bin/bash

WORKING_DIR="$(dirname $(readlink -f ${0}))"
ACTIVATE_PATH="$(dirname ${WORKING_DIR})/env3/bin/activate"

cd ${WORKING_DIR}
source ${ACTIVATE_PATH}

if [ $(git pull|grep "Already up-to-date."|wc -l) -ne 1 ] &&
   [ 1 -eq 1 ]
then
  pip3 install -r requirements.txt
  sudo cp cancollecter.conf /etc/supervisor/conf.d/cancollecter.conf
  sudo cp push2aws.conf /etc/supervisor/conf.d/push2aws.conf
  sudo service supervisor restart
fi
