#!/bin/bash

if [[ -z "$1" || $1 == 'start' ]]; then
  echo "Starting servers: MariaDB, PostgreSQL"
  sudo systemctl start mariadb
  sudo systemctl start postgresql
elif [[ $1 == 'stop' ]]; then
  echo "Stopping servers: MariaDB, PostgreSQL"
  sudo systemctl stop mariadb
  sudo systemctl stop postgresql
elif [[ $1 == '--maria' ]]; then
  echo "Starting server: MariaDB"
  sudo systemctl start mariadb
elif [[ $1 == '--pg' ]]; then
  echo "Starting server: PostgreSQL"
  sudo systemctl start postgresql
else
  echo "Available params: start, stop, --maria, --pg"
fi
