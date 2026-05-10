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
  - [x] Crear documento de sesión `docs/04_diario_laboratorio/20260509a_Sesion_Refactor_EscenarioA_HTB.md` (antes/después)
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
- [x] Verificar estado del trámite TFG en ETSINF para eliminar dependencia administrativa externa: propuesta APROBADA por el tutor el 2026-04-09, subida a EBRON el 2026-04-19 y oficialización completada (título oficial: *Análisis comparativo de seguridad entre modelos de Defensa Perimetral y Zero Trust en infraestructuras contenerizadas*).

# Diagnóstico de estado al 9 de mayo

## Lo que ya está cerrado

- Escenario A perimetral **funcionalmente completo**: 4 contenedores arrancan, healthcheck verde, cadena de ataque HTB-style validada end-to-end (recon → backup.txt → login → SSTI → RCE → lateral).
- Documentación de proceso al día: doc de sesión del refactor + apuntes técnicos SSTI + DECISIONS_LOG actualizado.

## Deuda pendiente

| Tipo | Tarea | Estimación | Bloqueante de |
|---|---|---|---|
| **D2 sub-tareas** | Capturas gráficas del navegador para la memoria | ~1.5h | T4, capítulo "Pruebas" |
| **D2 sub-tareas** | Cronometrar KPIs nuevos (sec. 7 del doc de refactor) | ~1h | Comparativa con Escenario B |
| **TODO T4** | Documentar flujo de ataque completo con capturas | ~2h | Capítulo "Pruebas" |
| **TODO T5** | Borrador "Estado del Arte" (NIST, IEEE, NIST 800-207, OWASP) | ~10-15h | Capítulo 2 de la memoria |
| **TODO T6** | Investigación Wazuh / Zero Trust | ~5-8h | Todo el Escenario B |

# Lo siguiente que tienes que hacer — recomendación

## Próximo paso inmediato: **cerrar el "antes" del Escenario A**

El roadmap pide entrar en mayo en **Escenario B (Zero Trust + Wazuh)**, pero **avanzar a ZT sin capturas/KPIs medidos del baseline perimetral te deja sin comparativa**, que es el corazón del TFG.

Concretamente, en este orden:

### 1. Capturas + cronometraje del ataque actual (~2.5h, hoy/mañana)

Ejecuta la cadena completa con el navegador en una sola sesión y captura:

| Captura | Qué muestra | KPI asociado |
|---|---|---|
| Portal `/` | UI corporativa benigna | T0 (inicio) |
| `curl -I` | header `X-Powered-By` | T_recon_http |
| `/robots.txt` | rutas señuelo | T_recon_rutas |
| `/backup.txt` | credenciales filtradas | T_disclosure |
| `/admin/login` form | Bootstrap card login | — |
| Dashboard tras login | Cookie de sesión activa | T_auth |
| `?host={{7*7}}` → `49` | confirmación SSTI | T_ssti_detect |
| `?host={{...popen('id')...}}` → `uid=0(root)` | RCE confirmada | T_rce |
| `?host={{...popen('env')...}}` → `DB_PASSWORD` | exfiltración credencial | T_exfil_creds |
| `?host={{...popen('curl backend')...}}` → JSON empleados | movimiento lateral | T_lateral |
| `psql -h db` desde `webapp` | dump completo de la DB | T_objetivo |

Guarda los tiempos en una tabla. Esa tabla **es** el "antes" del experimento principal.

Esto cierra D2, T2, T3 y T4 de una vez.

### 2. Decidir entre dos caminos en paralelo (próxima semana)

A partir de aquí tienes **dos vías de trabajo de naturaleza distinta** que puedes alternar para no estancarte:

#### Vía técnica → empezar Escenario B (T6 → Wazuh + Zero Trust)
- Investigar Wazuh (~3h): ¿qué es, cómo se despliega, qué reglas vienen out-of-the-box?
- Investigar Zero Trust práctico para Docker Compose (~3h): mTLS entre servicios, microsegmentación con redes Docker, secretos vía vault/Docker secrets, identidad con SPIFFE/OIDC.
- Diseñar `infra/zerotrust/docker-compose.yaml` siguiendo la misma estructura de 4 servicios pero con controles ZT sobre cada paso de la cadena de ataque que ya tienes documentada.

#### Vía académica → empezar T5 (Estado del Arte)
- Esqueleto del capítulo (~2h): introducción, secciones, índice.
- Revisión bibliográfica con las fuentes que ya tienes en `Apuntes_SSTI_Jinja2.md` sección 10 + las del prototipo perimetral.
- Redacción inicial: comparativa modelo perimetral vs Zero Trust, bases NIST 800-207, BeyondCorp Google, John Kindervag Forrester.

**Mi sugerencia operativa**: alterna las dos vías por bloques de 2-3h. La técnica te empuja el roadmap; la académica te paga la deuda del Cap 2 y queda lista cuando llegue julio (redacción intensiva).

### 3. Antes de tocar Wazuh: definir las políticas Zero Trust contra tu cadena

La sección 8 del [docs/01_investigacion/20260509b_Apuntes_SSTI_Jinja2.md](docs/01_investigacion/20260509b_Apuntes_SSTI_Jinja2.md) ya tiene la tabla mapeando cada paso del ataque a un control Zero Trust. Esa tabla **es la especificación de tu Escenario B**. Antes de instalar Wazuh, formaliza esa tabla en un nuevo `docs/01_investigacion/YYYYMMDD_Prototipo_ZeroTrust.md` (siguiendo la convención que acabamos de fijar).

# Riesgos a vigilar esta semana

| Riesgo | Mitigación |
|---|---|
| **Parálisis por exceso de detalle en capturas** | Timebox: 2.5h máximo. Si no terminas, mueve lo que falte a un nuevo D3 y sigue. |
| **Saltar al Escenario B sin medir el A** | Bloquea la fase Wazuh hasta tener la tabla de KPIs llena. |
| **Estado del Arte sigue posponiendo** | Reserva mínimo 2h/semana. Mejor empezar mal que no empezar. |
| **Mayo casi terminado y Escenario B sin tocar** | El roadmap acepta retraso del Escenario A si compensas con prototipo ZT mínimo viable antes de fin de mes. |

# Resumen ejecutivo

> **Esta semana:** capturas + KPIs del ataque actual (cierra D2 + T2-T4). 
> **Semana siguiente:** prototipo Escenario B en paralelo a borrador Estado del Arte.
> **Próximas 2 semanas:** Wazuh acoplado + medir ataque en Escenario B → comparativa lista para junio.

Cuando vuelvas a Agent mode y quieras avanzar puedo:
- Generar plantilla de tabla de KPIs en el doc de sesión.
- Crear `Prototipo_ZeroTrust.md` con la sección 8 del doc SSTI como base.
- Esqueleto inicial del capítulo "Estado del Arte" en `docs/03_memoria_tfg/`.
