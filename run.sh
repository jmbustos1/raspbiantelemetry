#!/bin/bash

WORKING_DIR="$(dirname $(readlink -f ${0}))"
ACTIVATE_PATH="$(dirname ${WORKING_DIR})/env3/bin/activate"

cd ${WORKING_DIR}
source ${ACTIVATE_PATH}
exec $@
