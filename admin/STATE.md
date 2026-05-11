# STATE - Seguimiento TFG Ciberseguridad

Fecha de actualizacion: 2026-05-10

## 1. Resumen Semanal
- Commits ultimos 7 dias: **9 entradas en git log**: 8 commits con aportacion directa (`774ff6e`, `bc668e8`, `6e865b0`, `a6a174e`, `af23ef4`, `51af93f`, `e4fac6c`, `e881bb2`) y 1 merge (`0b3d90a`).
- Trabajo completado segun commits: actualizacion semanal administrativa del 03/05, sesion de diseno del Escenario A, normalizacion de documentacion, implementacion funcional de servicios perimetrales (`backend`, `db`, `nginx`, `webapp`), refactor del vector de ataque a cadena multipaso tipo HTB, reorganizacion de diarios/apuntes y definicion de metodologia KPI para el Escenario A.
- Avance tecnico principal: el Escenario A paso de estructura Docker incompleta a laboratorio perimetral ejecutable y con cadena recon -> credenciales filtradas -> login -> SSTI -> RCE -> exfiltracion/movimiento lateral documentada.
- Avance metodologico principal: se anadieron decisiones ADR sobre SSTI, convencion documental, medicion G1/G3 y cobertura E3 mediante captura `tcpdump`, ademas de una plantilla KPI para registrar evidencias.
- Tendencia observada: alta recuperacion de velocidad y trazabilidad; la deuda se desplaza desde "hacer funcionar el Escenario A" hacia "cerrar evidencias/KPIs" y arrancar el Escenario B Zero Trust.

## 2. Comparativa y Retrasos
- Comparado con la semana anterior, la actividad sube de **6 a 9 entradas de log** (de 5 a 8 commits directos). La calidad del avance mejora: ya no es solo estructura inicial, sino implementacion, documentacion tecnica, ADRs y preparacion de medicion.
- Alineacion con `admin/ROADMAP.md`:
  - **Marzo-Abril (Escenario A perimetral):** retraso parcialmente corregido. El entorno perimetral y la cadena de ataque ya existen, pero faltan evidencias finales de captura, tiempos KPI y material listo para memoria.
  - **Mayo (Zero Trust + Wazuh):** retraso activo. El roadmap espera segmentacion, Wazuh y alertas, pero los commits de la semana siguen concentrados en cerrar el "antes" perimetral y su metodologia.
  - **Junio (experimento y medicion):** riesgo moderado si las mediciones del Escenario A no se completan de inmediato, porque la comparativa A/B depende de tener baseline cuantitativa.
- Delta principal: el proyecto recupera base tecnica y metodo de evaluacion, pero consume margen del bloque de mayo; la prioridad debe pasar a evidencia final A + especificacion minima de Escenario B.

## 3. Bloqueos
- Falta cerrar evidencias reproducibles del Escenario A: capturas de navegador, tabla de tiempos KPI, logs/capturas de conectividad y `.pcap` de trafico lateral para E3.
- Escenario B no iniciado en commits: no aparecen aun prototipo Zero Trust, despliegue Wazuh, microsegmentacion, mTLS ni alertas.
- Riesgo metodologico: empezar Wazuh sin congelar la baseline perimetral puede romper la comparabilidad del experimento.
- Riesgo academico: el borrador de "Estado del Arte" sigue pendiente frente al roadmap original y debe avanzar en paralelo al trabajo tecnico.
- Riesgo de dispersion documental: la reorganizacion de `docs/` fue positiva, pero conviene mantener estrictamente la convencion ADR para no perder trazabilidad.

## 4. Tablero del Sprint Actual
### TODO
- [ ] T7. Completar sesion de captura del Escenario A: navegador, consola, tabla de tiempos KPI y evidencia `.pcap` para E3.
- [ ] T8. Crear especificacion inicial del Escenario B Zero Trust usando la tabla de controles contra la cadena de ataque A.
- [ ] T9. Estudiar despliegue minimo de Wazuh/SIEM aplicable a Docker Compose y documentar decisiones de integracion.
- [ ] T10. Redactar esqueleto del capitulo "Estado del Arte" con NIST 800-207, BeyondCorp, OWASP y comparacion perimetral vs Zero Trust.
- [ ] T11. Preparar backlog tecnico para `infra/zerotrust/`: redes, identidad entre servicios, control de secretos, observabilidad y criterios de bloqueo.

### DOING
- [ ] D3. Cerrar baseline cuantitativa del Escenario A antes de cambiar a Zero Trust.
  - [ ] Ejecutar cadena completa en una sesion controlada.
  - [ ] Rellenar `tests/00_PLANTILLA_KPI.md` con valores G1, G2, G3, E1, E2 y E3.
  - [ ] Guardar capturas y logs reproducibles para memoria.
  - [ ] Confirmar que metricas quedan como ausencia documentada por diseno perimetral.
- [ ] D4. Iniciar diseno de Escenario B sin modificar todavia la comparativa A.
  - [ ] Mapear cada paso del ataque A contra un control Zero Trust.
  - [ ] Identificar que eventos debe generar Wazuh para G1/G3.
  - [ ] Definir criterio de exito: trafico ilegitimo cortado y alerta generada.

### DONE
- [x] D2. Refactorizar Escenario A hacia formato HTB Academy: portal Bootstrap, `robots.txt`, `backup.txt`, login, dashboard, SSTI autenticado, RCE y movimiento lateral documentado.
- [x] D1. Completar codigo fuente de `infra/perimetral/` para hacer el entorno ejecutable: `backend`, `db`, `nginx`, `webapp`, requisitos y configuracion base.
- [x] Definir esquema KPI del Escenario A: G1/G3 como tupla mecanismo/valor y E3 mediante captura `tcpdump`.
- [x] Crear `tests/00_PLANTILLA_KPI.md` para registrar evidencias cuantitativas.
- [x] Reorganizar documentacion a convencion `docs/01_investigacion/`, `docs/02_reuniones_tutor/`, `docs/03_memoria_tfg/`, `docs/04_diario_laboratorio/`.
- [x] Registrar ADRs del 09/05 y 10/05 en `admin/DECISIONS_LOG.md`.
- [x] Actualizacion semanal de artefactos de gestion (`STATE.md` y reporte ejecutivo del 26/04).
- [x] Revision de directrices y bitacora de reuniones de tutoria.
- [x] Estructura base de carpetas del proyecto normalizada con `.gitkeep`.
- [x] Inicio tecnico del Escenario A perimetral: `docker-compose.yaml` con redes y servicios base.
- [x] Actualizacion semanal de artefactos de gestion (`STATE.md` y reporte ejecutivo del 06/04).
- [x] Normalizacion del log de decisiones a `admin/DECISIONS_LOG.md`.
- [x] Carga inicial de investigacion tecnica Docker (`20260412_Apuntes_Docker101.md`).
- [x] Documento de diseno del Escenario A: `docs/01_investigacion/20260419_Prototipo_Red_Perimetral.md` (arquitectura, modelo de amenaza, flujo de ataque, KPIs).
- [x] `infra/perimetral/docker-compose.yaml` con estructura de servicios y redes creado.
- [x] Verificar estado del tramite TFG en ETSINF para eliminar dependencia administrativa externa: propuesta aprobada por el tutor el 2026-04-09, subida a EBRON el 2026-04-19 y oficializacion completada.
