#!/bin/bash

WORKING_DIR="$(dirname $(readlink -f ${0}))"
cd ${WORKING_DIR}

conf_dirs="${@}"

for conf_dir in ${conf_dirs}
do
  for file in $(find ${conf_dir} -type f)
  do
    root_file="/${file}"
    root_dir="$(dirname ${root_file})"
    mkdir -p ${root_dir}
    cp ${file} ${root_file}
  done
done
