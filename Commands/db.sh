#!/bin/bash

if [[ -z "$1" || $1 == 'start' ]]; then
  echo "Starting servers: MariaDB"
  sudo systemctl start mariadb
elif [[ $1 == 'stop' ]]; then
  echo "Stopping servers"
  sudo systemctl stop mariadb
else
  echo "Available params: start, stop"
fi
