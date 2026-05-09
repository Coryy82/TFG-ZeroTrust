# STATE - Seguimiento TFG Ciberseguridad

Fecha de actualización: 2026-05-03

## 1. Resumen Semanal
- Commits últimos 7 días: **6 entradas en git log**: 5 commits con aportación directa (`44c6f59`, `bed8a71`, `0162c17`, `b82d43c`, `e534d29`) y 1 merge (`1e57bc4`).
- Trabajo completado según commits: actualización administrativa del 26/04, revisión de directrices y bitácora de tutoría, creación de estructura base de carpetas, inicialización del Escenario A perimetral con `docker-compose.yaml`, redes `net_dmz` / `net_interna` y servicios `nginx`, `webapp`, `backend` y `db`.
- Evidencia adicional: el diario de laboratorio del 03/05 confirma que el montaje perimetral ha empezado, pero que todavía faltan las imágenes/código de front y back, configuración de nginx e `init.sql`.
- Tendencia observada: mejora de actividad frente a la semana anterior y primer avance técnico tangible; el entregable sigue siendo parcial porque el entorno aún no levanta ni tiene pruebas reproducibles.

## 2. Comparativa y Retrasos
- Comparado con la semana anterior, la actividad sube de **1 a 6 entradas de log** (5 commits directos) y pasa de gestión pura a trabajo mixto administrativo, documental y técnico.
- Alineación con `admin/ROADMAP.md`:
  - **Marzo-Abril (Escenario A perimetral):** retraso aún alto, aunque con avance parcial. Ya existe `docker-compose.yaml` y estructura de servicios, pero no hay entorno ejecutable, conectividad validada, bloqueo simple ni capturas.
  - **Mayo (Zero Trust + Wazuh):** desalineación crítica de arranque. El roadmap espera segmentación y visibilidad, pero primero debe cerrarse una baseline perimetral medible.
- Delta principal: se reduce el bloqueo inicial de implementación, pero se mantiene deuda técnica y académica en Estado del Arte, evidencias de laboratorio y validación del Escenario A.

## 3. Bloqueos
- Entorno perimetral no ejecutable: `webapp`, `backend`, `nginx.conf` e `init.sql` siguen vacíos según los ficheros y el diario de laboratorio.
- Posible bloqueo técnico en Docker Compose: el diario indica que montar el compose "ha costado" y que la red todavía no levanta.
- Falta de evidencias reproducibles para cerrar el Escenario A: no constan logs de `docker compose up`, pruebas de conectividad, capturas ni validación de movimiento lateral.
- Riesgo metodológico: avanzar a Zero Trust/Wazuh sin baseline perimetral funcional compromete la comparativa central del TFG.
- Riesgo académico: el borrador de "Estado del Arte" sigue pendiente pese a estar previsto en marzo-abril.

## 4. Tablero del Sprint Actual
### TODO
- [ ] T2. Ejecutar `docker compose up --build` tras completar los ficheros pendientes y guardar log de arranque.
- [ ] T3. Ejecutar prueba de conectividad completa entre contenedores y guardar evidencia (captura + log de comandos).
- [ ] T4. Documentar flujo de ataque completo (pasos 1-6 de `20260419_Prototipo_Red_Perimetral.md`) con capturas de evidencia.
- [ ] T5. Redactar borrador del capítulo "Estado del Arte" con base NIST/IEEE y referencias iniciales.
- [ ] T6. Iniciar investigación mínima de Wazuh/Zero Trust solo después de validar la baseline perimetral.

### DOING
- [ ] D2. Refactorizar Escenario A hacia formato HTB Academy (cadena multipaso).
  - [x] Crear plantillas Bootstrap 5 en `webapp/templates/` (base, portal, login, dashboard, diagnostico)
  - [x] Crear `webapp/static/robots.txt` con `Disallow:` señuelos
  - [x] Crear `webapp/static/backup.txt` con credenciales del panel admin (information disclosure)
  - [x] Reescribir `webapp/app.py`: rutas nuevas `/admin`, `/admin/login`, `/admin/logout`, `/admin/dashboard`, `/admin/diagnostico`
  - [x] Implementar sesión Flask + decorator `login_required`
  - [x] Sustituir `os.popen` por SSTI Jinja2 vía `render_template_string` (CWE-1336/CWE-94)
  - [x] Añadir header `X-Powered-By: Empresa-Portal/1.4.2` (CWE-200 fingerprint)
  - [x] Actualizar `webapp/Dockerfile` para copiar `templates/` y `static/`
  - [x] Validar cadena end-to-end: recon → backup.txt → login → SSTI `{{7*7}}` → RCE `id` → exfiltración `env` → lateral `curl backend`
  - [x] Crear documento de sesión `docs/01_investigacion/20260509a_Sesion_Refactor_EscenarioA_HTB.md` (antes/después)
  - [x] Registrar decisión en `admin/DECISIONS_LOG.md`
  - [ ] Capturar evidencias gráficas (capturas de navegador) para la memoria del TFG
  - [ ] Cronometrar KPIs nuevos definidos en `20260509a_Sesion_Refactor_EscenarioA_HTB.md` sección 7

### DONE
- [x] D1. Completar código fuente de `infra/perimetral/` para hacer el entorno ejecutable (4 contenedores arrancan, healthcheck verde, validado el 7/05).
- [x] Actualización semanal de artefactos de gestión (`STATE.md` y reporte ejecutivo del 26/04).
- [x] Revisión de directrices y bitácora de reuniones de tutoría.
- [x] Estructura base de carpetas del proyecto normalizada con `.gitkeep`.
- [x] Inicio técnico del Escenario A perimetral: `docker-compose.yaml` con redes y servicios base.
- [x] Actualización semanal de artefactos de gestión (`STATE.md` y reporte ejecutivo del 06/04).
- [x] Normalización del log de decisiones a `admin/DECISIONS_LOG.md`.
- [x] Carga inicial de investigación técnica Docker (`20260412_Apuntes_Docker101.md`).
- [x] Documento de diseño del Escenario A: `docs/01_investigacion/20260419_Prototipo_Red_Perimetral.md` (arquitectura, modelo de amenaza, flujo de ataque, KPIs).
- [x] `infra/perimetral/docker-compose.yaml` con estructura de servicios y redes creado.
- [x] Verificar estado del trámite TFG en ETSINF para eliminar dependencia administrativa externa: TFG oficializado y subido a plataforma