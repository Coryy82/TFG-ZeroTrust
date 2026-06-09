#!/bin/bash
set -e

MANAGER="${WAZUH_MANAGER:-wazuh-manager}"
AGENT_NAME="${WAZUH_AGENT_NAME:-zt-lab-agent}"
KEYS_FILE="/var/ossec/etc/client.keys"

echo "[wazuh-agent] Esperando a que el manager responda en ${MANAGER}:1515..."
until nc -z "${MANAGER}" 1515 2>/dev/null; do
    echo "[wazuh-agent] Manager no disponible, reintentando en 5s..."
    sleep 5
done
echo "[wazuh-agent] Manager listo."

if [ -s "${KEYS_FILE}" ]; then
    echo "[wazuh-agent] Ya enrollado (${KEYS_FILE} presente); omitiendo agent-auth."
else
    echo "[wazuh-agent] Registrando agente '${AGENT_NAME}'..."
    if ! /var/ossec/bin/agent-auth -m "${MANAGER}" -A "${AGENT_NAME}" -p 1515; then
        echo "[wazuh-agent] ERROR: agent-auth falló." >&2
        echo "[wazuh-agent] Si el manager ya tiene '${AGENT_NAME}' pero este contenedor no tiene clave:" >&2
        echo "  docker exec wazuh-wazuh-manager-1 /var/ossec/bin/manage_agents -l" >&2
        echo "  docker exec wazuh-wazuh-manager-1 /var/ossec/bin/manage_agents -r <ID>" >&2
        echo "  docker compose -f infra/zero_trust/wazuh/docker-compose.yaml up -d --force-recreate wazuh-agent" >&2
        exit 1
    fi
    echo "[wazuh-agent] Enrollment OK."
fi

echo "[wazuh-agent] Iniciando todos los servicios..."
/var/ossec/bin/wazuh-control start
echo "[wazuh-agent] Agente en marcha."
exec tail -f /var/ossec/logs/ossec.log
