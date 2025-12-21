#!/bin/bash

if [[ $1 == 'start' ]]; then
  echo "Starting LAMP stack"
  sudo systemctl start httpd mariadb
elif [[ $1 == 'stop' ]]; then
  echo "Stopping LAMP stack"
  sudo systemctl stop httpd mariadb
else
  echo "Available params: start, stop"
fi
