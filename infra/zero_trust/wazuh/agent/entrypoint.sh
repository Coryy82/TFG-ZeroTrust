#!/bin/bash
set -e

MANAGER="${WAZUH_MANAGER:-wazuh-manager}"
AGENT_NAME="${WAZUH_AGENT_NAME:-zt-lab-agent}"

echo "[wazuh-agent] Esperando a que el manager responda en ${MANAGER}:1515..."
until nc -z "${MANAGER}" 1515 2>/dev/null; do
    echo "[wazuh-agent] Manager no disponible, reintentando en 5s..."
    sleep 5
done
echo "[wazuh-agent] Manager listo."

echo "[wazuh-agent] Registrando agente '${AGENT_NAME}'..."
/var/ossec/bin/agent-auth -m "${MANAGER}" -A "${AGENT_NAME}" -p 1515

echo "[wazuh-agent] Iniciando todos los servicios..."
/var/ossec/bin/wazuh-control start
echo "[wazuh-agent] Agente en marcha."
exec tail -f /var/ossec/logs/ossec.log