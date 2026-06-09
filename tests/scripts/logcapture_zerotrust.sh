#!/usr/bin/env bash
# Captura de evidencias del Escenario B (Zero Trust): arranque, pausa para ataque manual,
# copia de artefactos post-RCE desde webapp, volcado de logs, alertas Wazuh y opcionalmente
# bajada del entorno.
#
# Uso (desde la raíz del repositorio o desde tests/scripts/):
#   chmod +x tests/scripts/logcapture_zerotrust.sh
#   ./tests/scripts/logcapture_zerotrust.sh
#
# Flujo:
#   1. Levanta infra/zero_trust (crea redes zero_trust_*).
#   2. Levanta Wazuh (requiere esas redes externas ya existentes).
#   3. Ejecutas pre-RCE + RCE + post-RCE en otra terminal (ver tests/POST-RCE comandos y notas.txt).
#   4. Pulsas ENTER aquí → copia /tmp/*, logs, wazuh_alerts.json a SESSION.
#
# Requisitos: Docker Compose v2, daemon activo. Wazuh recomendado (process-webapp cada 2s).

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
  session_chrono.txt
  t0_efectivo.txt
  creds.txt
  e1_scan.log
  lateral.pcap
  lateral_attempt.log
  lateral.json
  dump.txt
  tcpdump.log
)

mkdir -p "${SESSION}"

# Ruta visible para otras terminales / notas de laboratorio
echo "${SESSION}" > "${REPO_ROOT}/tests/.last_zerotrust_session"
git -C "${REPO_ROOT}" rev-parse HEAD > "${SESSION}/session_meta.txt" 2>/dev/null || true
echo "compose_file=${COMPOSE_FILE}" >> "${SESSION}/session_meta.txt"
date -Iseconds >> "${SESSION}/session_meta.txt" 2>/dev/null || date >> "${SESSION}/session_meta.txt"

echo "==> Directorio de sesión: ${SESSION}"
echo "==> (también en tests/.last_zerotrust_session)"
echo "==> Compose: ${COMPOSE_DIR}"
echo

cd "${COMPOSE_DIR}"

echo "==> [1/7] docker compose up --build -d ZT (salida en compose_up.log)"
if ! docker compose up --build -d 2>&1 | tee "${SESSION}/compose_up.log"; then
  echo "ERROR: docker compose up falló. Revisa compose_up.log" >&2
  exit 1
fi

if [[ -f "${WAZUH_COMPOSE}" ]]; then
  echo "==> [2/7] Wazuh: build + up (tras redes zero_trust_*; process-webapp cada 2s)"
  if docker compose -f "${WAZUH_COMPOSE}" up --build -d 2>&1 | tee "${SESSION}/wazuh_up.log"; then
    echo "    Esperando manager healthy (sin reiniciar agente si ya enrollado)..."
    sleep 8
    if docker exec wazuh-wazuh-agent-1 bash /var/ossec/scripts/process-webapp.sh 2>/dev/null \
        | grep -qv 'no-webapp-container'; then
      echo "    OK   process-webapp ve procesos en webapp"
    else
      echo "    AVISO process-webapp no ve webapp; espera ~15s antes del RCE" >&2
      sleep 5
      if docker exec wazuh-wazuh-agent-1 bash /var/ossec/scripts/process-webapp.sh 2>/dev/null \
          | grep -qv 'no-webapp-container'; then
        echo "    OK   process-webapp ve procesos en webapp (2º intento)"
      fi
    fi
  else
    echo "    AVISO: Wazuh no levantó; la sesión continúa sin SIEM" >&2
  fi
else
  echo "==> [2/7] AVISO: no se encontró ${WAZUH_COMPOSE}; Wazuh omitido"
fi

echo
echo "-------------------------------------------------------------------"
echo "  ENTORNO ZT + WAZUH LISTOS."
echo
echo "  SESSION=${SESSION}"
echo
echo "  Terminal 2 (host):  ncat -lvnp 4444"
echo "  Terminal 3 (navegador): cadena pre-RCE → SSTI → reverse shell"
echo "  Reverse shell:      estabilizar PS1 + registrar T0 (ver POST-RCE notas)"
echo "  Post-RCE:           comandos en tests/POST-RCE comandos y notas.txt"
echo
echo "  Guarda en webapp:/tmp/ antes de pulsar ENTER:"
for f in "${WEBAPP_ARTIFACTS[@]}"; do
  echo "    - /tmp/${f}"
done
echo
echo "  Cuando hayas terminado TODO el post-RCE, vuelve aquí y pulsa ENTER."
echo "-------------------------------------------------------------------"
read -r -p "Pulsa ENTER para continuar con la captura... " _

echo
echo "==> [3/7] Copiando artefactos post-RCE desde webapp:/tmp/"
copied=0
missing=0
empty=0
for f in "${WEBAPP_ARTIFACTS[@]}"; do
  dest="${SESSION}/${f}"
  if docker compose cp "webapp:/tmp/${f}" "${dest}" 2>/dev/null; then
    if [[ -s "${dest}" ]]; then
      echo "    OK   ${f} ($(wc -c < "${dest}" | tr -d ' ') bytes)"
      copied=$((copied + 1))
    else
      echo "    AVISO ${f} copiado pero vacío (0 bytes)"
      empty=$((empty + 1))
    fi
  else
    echo "    --   ${f} no encontrado en webapp:/tmp/"
    missing=$((missing + 1))
  fi
done
if [[ "${missing}" -gt 0 || "${empty}" -gt 0 ]]; then
  echo
  echo "  Resumen artefactos: ${copied} OK, ${empty} vacíos, ${missing} ausentes."
  echo "  Si lateral.pcap está vacío, repite el bloque tcpdump en webapp y pulsa ENTER de nuevo"
  echo "  O copia manualmente:"
  echo "    docker compose -f ${COMPOSE_FILE} cp webapp:/tmp/lateral.pcap ${SESSION}/"
fi

echo
echo "==> [4/7] Volcando logs por servicio (con timestamps, sin ANSI)"
for svc in "${SERVICES[@]}"; do
  echo "    ... ${svc}"
  docker compose logs -t --no-color "${svc}" > "${SESSION}/${svc}.log" 2>&1 || true
done

echo
echo "==> [5/7] Volcando logs combinados"
docker compose logs -t --no-color > "${SESSION}/compose_all.log" 2>&1 || true

echo
echo "==> [6/7] Volcando alertas Wazuh (si el manager está activo)"
if docker exec wazuh-wazuh-manager-1 test -f /var/ossec/logs/alerts/alerts.json 2>/dev/null; then
  docker exec wazuh-wazuh-manager-1 cat /var/ossec/logs/alerts/alerts.json \
    > "${SESSION}/wazuh_alerts.json" 2>/dev/null || true
  if [[ -s "${SESSION}/wazuh_alerts.json" ]]; then
    echo "    OK   wazuh_alerts.json ($(wc -c < "${SESSION}/wazuh_alerts.json" | tr -d ' ') bytes)"
  else
    echo "    AVISO wazuh_alerts.json vacío"
  fi
else
  echo "    --   wazuh-wazuh-manager-1 no disponible; omitido"
fi

echo
echo "-------------------------------------------------------------------"
echo "  Evidencias en: ${SESSION}/"
echo
echo "  ¿Quieres detener y eliminar los contenedores (docker compose down)?"
echo "  Responde 's' o 'S' para bajarlos; cualquier otra tecla los deja en marcha."
echo "  (Si bajas ZT, las redes externas desaparecen; Wazuh debe bajarse aparte si aplica.)"
echo "-------------------------------------------------------------------"
read -r -p "¿Bajar el entorno ZT? [s/N] " resp
case "${resp}" in
  s|S)
    echo "==> [7/7] docker compose down (ZT)"
    docker compose down 2>&1 | tee "${SESSION}/compose_down.log"
    ;;
  *)
    echo "==> [7/7] Omitido: los contenedores ZT siguen activos."
    echo "    cd ${COMPOSE_DIR} && docker compose down"
    ;;
esac

echo
echo "==> Sesión finalizada. Ficheros:"
ls -la "${SESSION}"
