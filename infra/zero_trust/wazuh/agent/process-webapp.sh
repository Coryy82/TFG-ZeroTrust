#!/bin/bash
# Procesos dentro del contenedor webapp (reverse shell post-RCE).
# docker top falla en Docker Desktop; webapp no tiene ps → leer /proc via docker exec.
set -euo pipefail

NAME=$(docker ps \
  -f label=com.docker.compose.service=webapp \
  -f label=com.docker.compose.project=zero_trust \
  --format '{{.Names}}' | head -1)

if [ -z "${NAME}" ]; then
  echo "no-webapp-container"
  exit 0
fi

docker exec "${NAME}" sh -c '
for p in /proc/[0-9]*; do
  [ -r "$p/cmdline" ] || continue
  args=$(tr "\0" " " < "$p/cmdline" 2>/dev/null)
  [ -n "$args" ] && printf "%s\n" "$args"
done
' 2>/dev/null || echo "docker-exec-failed"
