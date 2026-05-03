# STATE - Seguimiento TFG Ciberseguridad

Fecha de actualización: 2026-05-03

## 1. Resumen Semanal
- Commits últimos 7 días: **10** (`e1527b3`, `e123e97`, `29ddeab`, `6394dd0`, `1d360b9`, `7b48170`, `ff4d052`, `01a067f`, `b529d71`, `c0b8523`).
- Trabajo completado: consolidación de la capa de gestión del proyecto (workflow administrativo, roadmap, estado y reportes), normalización documental (`DECISIONS_LOG.md`) y primer material técnico de investigación (`docs/01_investigacion/Apuntes Docker101.md`).
- Evidencia de retrabajo/control: secuencia commit experimental + revert en workflow (`e123e97` -> `29ddeab`), seguida de refactor estable (`6394dd0`, `7b48170`).
- Avance técnico del laboratorio: **sin entregables ejecutables** del escenario perimetral (no hay `docker-compose.yml` funcional ni pruebas de conectividad/bloqueo en commits).

## 2. Comparativa y Retrasos
- Frente al estado anterior, aumenta la disciplina de gestión (más trazabilidad y limpieza documental), pero la velocidad de implementación técnica sigue baja.
- Alineación con `admin/ROADMAP.md` (Marzo-Abril): **desalineación parcial**. Se avanzó en preparación y documentación, pero siguen pendientes los hitos críticos: Compose operativo, red plana validada, bloqueo simple y borrador consolidado del Estado del Arte.
- Delta semanal: mejora administrativa sostenida; retraso acumulado en hitos experimentales que condicionan los objetivos de mayo (Zero Trust + Wazuh).

## 3. Bloqueos
- Predominio de trabajo administrativo sobre construcción y validación del entorno reproducible.
- Ausencia de evidencias técnicas verificables (logs/capturas/scripts) para cerrar hitos del escenario A.
- Riesgo de arrastre hacia mayo: iniciar Zero Trust sin baseline perimetral medido debilita la comparativa experimental del TFG.
- Señales de fricción en priorización (commits de mantenimiento frecuentes sin cierre de tareas de laboratorio).

## 4. Tablero del Sprint Actual
### TODO
- [ ] T2. Ejecutar prueba de conectividad completa entre contenedores y guardar evidencia (captura + log de comandos).
- [ ] T3. Documentar flujo de ataque completo (pasos 1-6 de `Prototipo Red perimetral.md`) con capturas de evidencia.
- [ ] T4. Redactar borrador del capítulo "Estado del Arte" con base NIST/IEEE y referencias iniciales.
- [ ] T5. Definir y registrar KPI semanales del experimento (entregables cerrados, evidencia, riesgos abiertos).

### DOING
- [ ] D1. Completar código fuente de `infra/perimetral/` para hacer el entorno ejecutable.
  - [x] Estructura de ficheros `infra/perimetral/` creada
  - [x] `docker-compose.yaml` con redes `net_dmz` / `net_interna` y 4 servicios definidos
  - [ ] Rellenar `webapp/Dockerfile` + `webapp/app.py` (Flask con endpoint `/ping` vulnerable a RCE)
  - [ ] Crear y rellenar `webapp/requirements.txt` (`flask`)
  - [ ] Rellenar `backend/Dockerfile` + `backend/app.py` (Flask API interna sin autenticación)
  - [ ] Crear y rellenar `backend/requirements.txt` (`flask`, `psycopg2-binary`)
  - [ ] Rellenar `nginx/nginx.conf` (reverse proxy → `webapp:5000`)
  - [ ] Rellenar `db/init.sql` (tabla `usuarios` con datos sensibles de prueba)
  - [ ] Ejecutar `docker compose up --build` y verificar que los 4 servicios arrancan sin errores
- [ ] D2. Verificar estado del trámite TFG en ETSINF para eliminar dependencia administrativa externa.

### DONE
- [x] Actualización semanal de artefactos de gestión (`STATE.md` y reporte ejecutivo del 06/04).
- [x] Normalización del log de decisiones a `admin/DECISIONS_LOG.md`.
- [x] Carga inicial de investigación técnica Docker (`Apuntes Docker101.md`).
- [x] Documento de diseño del Escenario A: `docs/01_investigacion/Prototipo Red perimetral.md` (arquitectura, modelo de amenaza, flujo de ataque, KPIs).
- [x] `infra/perimetral/docker-compose.yaml` con estructura de servicios y redes creado.