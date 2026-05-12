#!/usr/bin/env bash
# Captura de evidencias del Escenario A (perimetral): arranque, pausa para ataque manual,
# volcado de logs por servicio y opcionalmente bajada del entorno.
#
# Uso (desde la raíz del repositorio):
#   chmod +x tests/scripts/logcapture_perimetral.sh
#   ./tests/scripts/logcapture_perimetral.sh
#
# Requisitos: Docker Compose v2, daemon activo.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
COMPOSE_DIR="${REPO_ROOT}/infra/perimetral"
LOG_ROOT="${REPO_ROOT}/tests/logs"
SESSION="${LOG_ROOT}/perimetral_sesion_$(date +%Y%m%d_%H%M%S)"

SERVICES=(nginx webapp backend db)

mkdir -p "${SESSION}"

echo "==> Directorio de sesión: ${SESSION}"
echo "==> Compose: ${COMPOSE_DIR}"
echo

cd "${COMPOSE_DIR}"

echo "==> [1/4] docker compose up --build -d (salida también en compose_up.log)"
if ! docker compose up --build -d 2>&1 | tee "${SESSION}/compose_up.log"; then
  echo "ERROR: docker compose up falló. Revisa compose_up.log" >&2
  exit 1
fi

echo
echo "-------------------------------------------------------------------"
echo "  ENTORNO LEVANTADO. Realiza el ataque manual (navegador, curl,"
echo "  tcpdump, etc.). Los contenedores siguen en ejecución."
echo
echo "  Cuando hayas terminado, vuelve a esta terminal y pulsa ENTER"
echo "  para volcar los logs de cada servicio a ficheros separados."
echo "-------------------------------------------------------------------"
read -r -p "Pulsa ENTER para continuar con la captura de logs... " _

echo
echo "==> [2/4] Volcando logs por servicio (con timestamps, sin ANSI)"
for svc in "${SERVICES[@]}"; do
  echo "    ... ${svc}"
  docker compose logs -t --no-color "${svc}" > "${SESSION}/${svc}.log" 2>&1 || true
done

echo
echo "==> [3/4] Volcando logs combinados (todos los servicios, una sola vista cronológica)"
docker compose logs -t --no-color > "${SESSION}/compose_all.log" 2>&1 || true

echo
echo "-------------------------------------------------------------------"
echo "  Logs guardados en:"
echo "    ${SESSION}/"
echo
echo "  ¿Quieres detener y eliminar los contenedores (docker compose down)?"
echo "  Responde 's' o 'S' para bajarlos; cualquier otra tecla los deja en marcha."
echo "-------------------------------------------------------------------"
read -r -p "¿Bajar el entorno? [s/N] " resp
case "${resp}" in
  s|S)
    echo "==> [4/4] docker compose down"
    docker compose down 2>&1 | tee "${SESSION}/compose_down.log"
    ;;
  *)
    echo "==> [4/4] Omitido: los contenedores siguen activos."
    echo "    Cuando quieras:"
    echo "      cd ${COMPOSE_DIR} && docker compose down"
    ;;
esac

echo
echo "==> Sesión finalizada. Ficheros:"
ls -la "${SESSION}"