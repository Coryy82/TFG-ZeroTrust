# STATE - Seguimiento TFG Ciberseguridad

Fecha de actualizacion: 2026-05-17

## 1. Resumen Semanal
- Commits ultimos 7 dias: **8 entradas en git log**: 7 commits con aportacion directa (`575c5f7`, `ff4df84`, `ceabaf2`, `650fec4`, `b2380c7`, `15d575e`, `7b80070`) y 1 merge (`2838d12`).
- Trabajo completado segun commits: captura operativa del Escenario A con payload RCE, logs, evidencias visuales y `lateral.pcap`; publicacion de `tests/00_PLANTILLA_KPI_v2.md`; ampliacion de `admin/DECISIONS_LOG.md` con la separacion metodologica pre-RCE/post-RCE; informe de estado del Escenario A; mejora del Dockerfile de `webapp`; y normalizacion menor de `.gitignore` en workflows.
- Avance tecnico principal: el Escenario A ya no esta solo disenado, sino respaldado por evidencias de ejecucion reproducibles para navegador, consola, logs de servicios, exfiltracion y trafico lateral.
- Avance metodologico principal: la comparativa A/B queda mejor acotada al instante `T0_efectivo` post-RCE, evitando mezclar reconocimiento/login/SSTI con los KPIs oficiales de microsegmentacion, deteccion y bloqueo.
- Tendencia observada: la velocidad sigue siendo saludable, pero el trabajo continua centrado en cerrar y ordenar el "antes" perimetral; el arranque efectivo de Escenario B Zero Trust/Wazuh sigue pendiente.

## 2. Comparativa y Retrasos
- Comparado con la semana anterior, la actividad baja ligeramente de **9 a 8 entradas de log** y de **8 a 7 commits directos**. La bajada no indica bloqueo: los commits contienen entregables pesados de evidencia, capturas, logs y plantilla KPI v2.
- Delta frente al tablero anterior:
  - La parte de ejecucion/captura de T7 avanza de forma sustancial: ya existen payload, capturas, logs y `pcap`.
  - Sigue pendiente convertir esa evidencia bruta en tabla KPI cerrada con valores G1, G2, G3, E1, E2 y E3.
  - T8-T11 permanecen activos: no hay commits que indiquen prototipo Zero Trust, Wazuh, microsegmentacion, mTLS o borrador academico consolidado.
- Alineacion con `admin/ROADMAP.md`:
  - **Marzo-Abril (Escenario A perimetral):** practicamente recuperado en laboratorio y evidencias, aunque falta consolidacion cuantitativa final.
  - **Mayo (Zero Trust + Wazuh):** retraso activo. El roadmap esperaba segmentacion, SIEM y alertas; el repositorio aun no muestra implementacion del Escenario B.
  - **Junio (experimento y medicion):** riesgo creciente si el sprint actual no convierte la baseline A en tabla final y no arranca B con controles medibles.

## 3. Bloqueos
- Bloqueo principal: el Escenario B no aparece iniciado en commits recientes. Sin red Zero Trust ni Wazuh, no hay contraste A/B para los KPIs de junio.
- Riesgo metodologico: existen evidencias brutas del Escenario A, pero falta curarlas en una tabla unica; logs y capturas sin valores consolidados no bastan para la memoria.
- Riesgo de re-trabajo: los cambios en Dockerfile y reorganizacion de logs sugieren pequenos ajustes de entorno; antes de tocar B conviene congelar la baseline A documentada.
- Riesgo academico: "Estado del Arte" y "Diseno de la Solucion" siguen por detras del roadmap y deben avanzar en paralelo al prototipo tecnico.
- Riesgo de foco: seguir refinando el Escenario A puede desplazar el objetivo de mayo, que es visibilidad, segmentacion y alerta en Zero Trust.

## 4. Tablero del Sprint Actual
### TODO
- [ ] T12. Consolidar la baseline A en `tests/00_PLANTILLA_KPI_v2.md`: valores G1, G2, G3, E1, E2, E3, rutas de evidencia y convenciones de infinito/0%.
- [ ] T13. Crear especificacion minima del Escenario B: controles Zero Trust contra cada hito post-RCE del Escenario A.
- [ ] T14. Iniciar prototipo `infra/zerotrust/` con separacion Web/BBDD, politicas de red y criterio de bloqueo verificable.
- [ ] T15. Estudiar despliegue minimo de Wazuh/SIEM en Docker Compose y decidir eventos obligatorios para G1/G3.
- [ ] T16. Redactar esqueletos de "Estado del Arte" y "Diseno de la Solucion" con NIST 800-207, BeyondCorp, OWASP y comparativa perimetral vs Zero Trust.
- [ ] T17. Preparar protocolo de pruebas A/B post-RCE: comandos, tiempos, evidencias esperadas y tabla comparativa final.

### DOING
- [ ] D5. Cerrar baseline cuantitativa del Escenario A antes de modificar la arquitectura comparativa.
  - [ ] Extraer tiempos y resultados desde capturas/logs existentes.
  - [ ] Validar que `lateral.pcap` evidencia E3 de trafico interno legible o ausencia de cifrado.
  - [ ] Vincular screenshots, logs y payload RCE a cada KPI.
  - [ ] Dejar lista una tabla defendible para la memoria.
- [ ] D6. Disenar el Escenario B Zero Trust con visibilidad desde el primer incremento.
  - [ ] Mapear cada hito post-RCE contra segmentacion, identidad de servicio, secretos y observabilidad.
  - [ ] Definir que alerta debe emitir Wazuh para G1.
  - [ ] Definir que bloqueo cuenta para G3.
  - [ ] Fijar criterio de exito: trafico ilegitimo cortado y evento trazable generado.

### DONE
- [x] Capturar evidencias brutas del Escenario A: RCE, screenshots, logs de servicios, `creds.txt`, `lateral.json` y `lateral.pcap`.
- [x] Publicar `tests/00_PLANTILLA_KPI_v2.md` con separacion pre-RCE/post-RCE y definicion de `T0_efectivo`.
- [x] Registrar ADR del 2026-05-12 sobre comparabilidad metodologica de KPIs post-RCE.
- [x] Crear informe tecnico de estado del Escenario A.
- [x] Mejorar soporte de entorno para la sesion perimetral mediante ajustes de Dockerfile y normalizacion de evidencias.
- [x] D2. Refactorizar Escenario A hacia formato HTB Academy: portal Bootstrap, `robots.txt`, `backup.txt`, login, dashboard, SSTI autenticado, RCE y movimiento lateral documentado.
- [x] D1. Completar codigo fuente de `infra/perimetral/` para hacer el entorno ejecutable: `backend`, `db`, `nginx`, `webapp`, requisitos y configuracion base.
- [x] Definir esquema KPI del Escenario A: G1/G3 como tupla mecanismo/valor y E3 mediante captura `tcpdump`.
- [x] Reorganizar documentacion a convencion `docs/01_investigacion/`, `docs/02_reuniones_tutor/`, `docs/03_memoria_tfg/`, `docs/04_diario_laboratorio/`.
- [x] Documento de diseno del Escenario A: `docs/01_investigacion/20260419_Prototipo_Red_Perimetral.md`.
