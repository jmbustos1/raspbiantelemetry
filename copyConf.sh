#!/bin/bash

export $(cat install.conf | xargs)
if [ -z ${APN+x} ]
then
  echo "APN is no set"
  exit 1
elif [ -z ${APN_USER+x} ]
then
  echo "APN_USER is no set"
  exit 1
elif [ -z ${APN_PASS+x} ]
then
  echo "APN_PASS is no set"
  exit 1
elif [ -z ${SSH_PORT+x} ]
then
  echo "SSH_PORT is no set"
  exit 1
fi

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

    cat ${file}| sed "s,\${APN_PASS},${APN_PASS},g" > file.aux0
    cat file.aux0| sed "s,\${APN_USER},${APN_USER},g" > file.aux1
    cat file.aux1| sed "s,\${APN},${APN},g" > file.aux0
    cat file.aux0| sed "s,\${SSH_PORT},${SSH_PORT},g" > ${root_file}

    chmod --reference=${file} ${root_file}
    rm -rf file.aux0 file.aux1
  done
done
