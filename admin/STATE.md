# STATE - Seguimiento TFG Ciberseguridad

Fecha de actualización: 2026-05-03

## 1. Resumen Semanal
- Commits últimos 7 días: **1** (`6058c3f`).
- Trabajo completado según commits: actualización administrativa del estado semanal y creación del reporte ejecutivo del 19/04.
- No se observa evidencia nueva de ejecución técnica del laboratorio: no hay commits con `docker-compose` funcional, pruebas de conectividad, capturas, logs, bloqueo lateral ni avances del borrador académico.
- Tendencia observada: continuidad mínima en seguimiento del proyecto, con velocidad técnica nula durante la semana.

## 2. Comparativa y Retrasos
- Comparado con la semana anterior, la actividad baja de **3 a 1 commit** y se concentra al 100% en gestión administrativa.
- Alineación con `admin/ROADMAP.md`:
  - **Marzo-Abril (Escenario A perimetral):** retraso alto. Siguen sin cerrarse los hitos de Docker Compose, conectividad entre contenedores, bloqueo simple y evidencias reproducibles.
  - **Mayo (Zero Trust + Wazuh):** riesgo de arranque condicionado. El roadmap exige iniciar segmentación y visibilidad, pero la baseline perimetral A todavía no está validada.
- Delta principal: se mantiene la trazabilidad administrativa, pero aumenta el retraso acumulado en entregables técnicos y académicos.

## 3. Bloqueos
- Inactividad técnica visible en Git durante la semana: solo se registra un commit administrativo.
- Falta de evidencias reproducibles para cerrar el Escenario A (comandos, logs, capturas o scripts de validación).
- Riesgo metodológico: avanzar a Zero Trust/Wazuh sin baseline perimetral medida compromete la comparativa central del TFG.
- Riesgo de arrastre académico: el borrador de "Estado del Arte" continúa pendiente pese a estar previsto en el bloque marzo-abril.

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
