#!/bin/bash

# copy files
cp etc/default/secure-tunnel.conf /etc/default/secure-tunnel.conf
cp etc/systemd/system/secure-tunnel@.service /etc/systemd/system/secure-tunnel@.service

# add ocpp.voltiosc.cl to list of known hosts
su -c "ssh-keyscan -t rsa -H ocpp.voltiosc.cl >> ~/.ssh/known_hosts"

# start daemon
systemctl enable --now secure-tunnel@ocpp
