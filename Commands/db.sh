#!/bin/bash

declare -A SERVICES=(
  [--maria]="MariaDB:mariadb"
  [--pg]="PostgreSQL:postgresql"
  [--rd]="Redis:redis-server"
  [--ollama]="Ollama:ollama"
)

do_action() {
  local action=$1 key=$2
  local name="${SERVICES[$key]%%:*}"
  local unit="${SERVICES[$key]##*:}"
  echo "${action^}ing server: $name"
  sudo systemctl "$action" "$unit"
}

arg="${1:-start}"

if [[ "$arg" == "start" || "$arg" == "stop" ]]; then
  echo "${arg^}ing servers: ${SERVICES[*]%%:*}"
  for key in "${!SERVICES[@]}"; do
    do_action "$arg" "$key"
  done
elif [[ -n "${SERVICES[$arg]+set}" ]]; then
  do_action start "$arg"
else
  echo "Available params: start, stop, ${!SERVICES[*]}"
fi
