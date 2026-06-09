#!/usr/bin/env bash
# Captura de evidencias del Escenario A (perimetral): arranque, pausa para ataque manual,
# copia de artefactos post-RCE desde webapp, volcado de logs por servicio y opcionalmente
# bajada del entorno.
#
# Uso (desde la raíz del repositorio):
#   chmod +x tests/scripts/logcapture_perimetral.sh
#   ./tests/scripts/logcapture_perimetral.sh
#
# Requisitos: Docker Compose v2, daemon activo.
# Los ficheros en webapp:/tmp/ deben existir antes de pulsar ENTER (se pierden con compose down).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
COMPOSE_DIR="${REPO_ROOT}/infra/perimetral"
LOG_ROOT="${REPO_ROOT}/tests/logs"
SESSION="${LOG_ROOT}/perimetral_sesion_$(date +%Y%m%d_%H%M%S)"

SERVICES=(nginx webapp backend db)
WEBAPP_ARTIFACTS=(lateral.pcap lateral.json creds.txt dump.txt e1_scan.log)

mkdir -p "${SESSION}"

echo "==> Directorio de sesión: ${SESSION}"
echo "==> Compose: ${COMPOSE_DIR}"
echo

cd "${COMPOSE_DIR}"

echo "==> [1/5] docker compose up --build -d (salida también en compose_up.log)"
if ! docker compose up --build -d 2>&1 | tee "${SESSION}/compose_up.log"; then
  echo "ERROR: docker compose up falló. Revisa compose_up.log" >&2
  exit 1
fi

echo
echo "-------------------------------------------------------------------"
echo "  ENTORNO LEVANTADO. Realiza el ataque manual (navegador, RCE,"
echo "  tcpdump, curl lateral, psql, etc.). Los contenedores siguen activos."
echo
echo "  Guarda en webapp bajo /tmp/:"
for f in "${WEBAPP_ARTIFACTS[@]}"; do
  echo "    - /tmp/${f}"
done
echo
echo "  Cuando hayas terminado, vuelve a esta terminal y pulsa ENTER"
echo "  para copiar artefactos y volcar logs (antes de compose down)."
echo "-------------------------------------------------------------------"
read -r -p "Pulsa ENTER para continuar con la captura... " _

echo
echo "==> [2/5] Copiando artefactos post-RCE desde webapp:/tmp/"
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
      echo "    AVISO ${f} copiado pero vacío (0 bytes) — revisar comando en webapp"
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
  echo "  Si faltan lateral.pcap o dump.txt, repite esos pasos en webapp antes de bajar compose."
fi

echo
echo "==> [3/5] Volcando logs por servicio (con timestamps, sin ANSI)"
for svc in "${SERVICES[@]}"; do
  echo "    ... ${svc}"
  docker compose logs -t --no-color "${svc}" > "${SESSION}/${svc}.log" 2>&1 || true
done

echo
echo "==> [4/5] Volcando logs combinados (todos los servicios, una sola vista cronológica)"
docker compose logs -t --no-color > "${SESSION}/compose_all.log" 2>&1 || true

echo
echo "-------------------------------------------------------------------"
echo "  Evidencias en: ${SESSION}/"
echo
echo "  ¿Quieres detener y eliminar los contenedores (docker compose down)?"
echo "  Responde 's' o 'S' para bajarlos; cualquier otra tecla los deja en marcha."
echo "  (Tras 'down', /tmp/ del contenedor webapp ya no será accesible.)"
echo "-------------------------------------------------------------------"
read -r -p "¿Bajar el entorno? [s/N] " resp
case "${resp}" in
  s|S)
    echo "==> [5/5] docker compose down"
    docker compose down 2>&1 | tee "${SESSION}/compose_down.log"
    ;;
  *)
    echo "==> [5/5] Omitido: los contenedores siguen activos."
    echo "    Cuando quieras:"
    echo "      cd ${COMPOSE_DIR} && docker compose down"
    ;;
esac

echo
echo "==> Sesión finalizada. Ficheros:"
ls -la "${SESSION}"
