#!/bin/bash

# check copy files
if [ test -f "/etc/default/secure-tunnel.conf" ] &&
   [ test -f "/etc/systemd/system/secure-tunnel@.service" ]
then
  # add ocpp.voltiosc.cl to list of known hosts
  su -c "mkdir -p ~/.ssh"
  su -c "ssh-keyscan -t rsa -H ocpp.voltiosc.cl >> ~/.ssh/known_hosts"

  # start daemon
  systemctl enable --now secure-tunnel@ocpp
fi
