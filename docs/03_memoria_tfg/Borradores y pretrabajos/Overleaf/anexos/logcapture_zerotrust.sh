#!/usr/bin/env bash
# Captura de evidencias del Escenario B (Zero Trust): arranque, pausa para ataque manual,
# copia de artefactos post-RCE desde webapp, volcado de logs, alertas Wazuh y opcionalmente
# bajada del entorno.
#
# Flujo:
#   1. Levanta infra/zero_trust (crea redes zero_trust_*).
#   2. Levanta Wazuh (requiere esas redes externas ya existentes).
#   3. Se ejecuta pre-RCE + RCE + post-RCE en otra terminal.
#   4. Al pulsar ENTER -> copia /tmp/*, logs y wazuh_alerts.json a la carpeta de sesion.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
COMPOSE_DIR="${REPO_ROOT}/infra/zero_trust"
COMPOSE_FILE="${COMPOSE_DIR}/docker-compose.yaml"
WAZUH_COMPOSE="${REPO_ROOT}/infra/zero_trust/wazuh/docker-compose.yaml"
LOG_ROOT="${REPO_ROOT}/tests/logs"
SESSION="${LOG_ROOT}/zerotrust_sesion_$(date +%Y%m%d_%H%M%S)"

SERVICES=(nginx webapp backend db)
WEBAPP_ARTIFACTS=(
  session_chrono.txt t0_efectivo.txt creds.txt e1_scan.log
  lateral.pcap lateral_attempt.log lateral.json dump.txt tcpdump.log
)

mkdir -p "${SESSION}"

cd "${COMPOSE_DIR}"

echo "==> [1/7] docker compose up --build -d ZT"
docker compose up --build -d 2>&1 | tee "${SESSION}/compose_up.log"

if [[ -f "${WAZUH_COMPOSE}" ]]; then
  echo "==> [2/7] Wazuh: build + up (tras redes zero_trust_*; process-webapp cada 2s)"
  docker compose -f "${WAZUH_COMPOSE}" up --build -d 2>&1 | tee "${SESSION}/wazuh_up.log"
  sleep 8
fi

echo "  Ejecuta el post-RCE en otra terminal y pulsa ENTER al terminar."
read -r -p "Pulsa ENTER para continuar con la captura... " _

echo "==> [3/7] Copiando artefactos post-RCE desde webapp:/tmp/"
for f in "${WEBAPP_ARTIFACTS[@]}"; do
  docker compose cp "webapp:/tmp/${f}" "${SESSION}/${f}" 2>/dev/null \
    && echo "    OK   ${f}" || echo "    --   ${f} ausente"
done

echo "==> [4/7] Volcando logs por servicio"
for svc in "${SERVICES[@]}"; do
  docker compose logs -t --no-color "${svc}" > "${SESSION}/${svc}.log" 2>&1 || true
done

echo "==> [5/7] Volcando logs combinados"
docker compose logs -t --no-color > "${SESSION}/compose_all.log" 2>&1 || true

echo "==> [6/7] Volcando alertas Wazuh (si el manager esta activo)"
docker exec wazuh-wazuh-manager-1 cat /var/ossec/logs/alerts/alerts.json \
  > "${SESSION}/wazuh_alerts.json" 2>/dev/null || true

echo "==> [7/7] Sesion finalizada. Evidencias en: ${SESSION}/"
read -r -p "¿Bajar el entorno ZT? [s/N] " resp
case "${resp}" in
  s|S) docker compose down 2>&1 | tee "${SESSION}/compose_down.log" ;;
  *)   echo "Contenedores ZT siguen activos." ;;
esac
