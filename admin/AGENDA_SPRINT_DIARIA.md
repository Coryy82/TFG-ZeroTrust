# AGENDA SPRINT DIARIA — 21/06/2026

> **Deadline fijo:** 21/06/2026  
> **Archivo de tareas:** `.cursor/plans/tfg_zerotrust_sprint_final_40490aa8.plan.md`  
> **Archivo de hoy:** `admin/HOY.md` — sobrescribir cada mañana con el día actual  
> **Regla de cierre:** ningún capítulo se reabre una vez cerrado en borrador  
> **Timeboxing:** si un problema técnico supera 2h sin avance → simplificar o activar fallback

---

## FECHAS CRÍTICAS

| Fecha      | Evento                                                          |
|------------|-----------------------------------------------------------------|
| **31/05**  | ⚠️ EMAIL TUTOR — EdA v0 + índice + propuesta Escenario B       |
| **04/06**  | ⚠️ CHECKPOINT WAZUH 20:00 — continuar o switch a Falco         |
| **09/06**  | Límite: Escenario B funcional + KPIs §2/§3 cerrados            |
| **14/06**  | ⚠️ EMAIL TUTOR — memoria 60-70% + setup Overleaf               |
| **19/06**  | ⚠️ EMAIL TUTOR — PDF compilado completo                        |
| **21/06**  | ⚠️ ENTREGA — PDF depositado en plataforma                      |

---

## FASE 1 — SEMANA 1 (25/05–31/05) · 1-2h/día · Objetivo: borrador para tutor

---

### 2026-05-25 — EdA: contenedores y perimetral
- **Objetivo:** redactar §2.1 y §2.2 del Estado del Arte
- **Presupuesto:** 1.5h
- **Plan:** `redactar_eda_v0` (parcial)
- [ ] Redactar `docs/03_memoria_tfg/02_estado_arte.md` §2.1 "Evolución hacia infraestructuras contenerizadas" — *insumo: `docs/01_investigacion/20260412_Apuntes_Docker101.md`* — 45 min
- [ ] Redactar `docs/03_memoria_tfg/02_estado_arte.md` §2.2 "El modelo perimetral y sus limitaciones" — 40 min
- [ ] Añadir 2-3 entradas a `docs/03_memoria_tfg/99_bibliografia.md` (NIST 800-207, Docker networking doc) — 15 min

---

### 2026-05-26 — EdA: Zero Trust y BeyondCorp
- **Objetivo:** redactar §2.3 y §2.4 del Estado del Arte
- **Presupuesto:** 1.5h
- **Plan:** `redactar_eda_v0` (parcial)
- [ ] Redactar `docs/03_memoria_tfg/02_estado_arte.md` §2.3 "El modelo Zero Trust" — *fuentes: NIST SP 800-207, paper BeyondCorp 2014* — 45 min
- [ ] Redactar `docs/03_memoria_tfg/02_estado_arte.md` §2.4 "Microsegmentación en entornos contenerizados" — 40 min
- [ ] Añadir referencias a `docs/03_memoria_tfg/99_bibliografia.md` — 10 min

---

### 2026-05-27 — EdA: SIEM y amenazas
- **Objetivo:** redactar §2.5 y §2.6 del Estado del Arte
- **Presupuesto:** 1.5h
- **Plan:** `redactar_eda_v0` (parcial)
- [ ] Redactar `docs/03_memoria_tfg/02_estado_arte.md` §2.5 "Sistemas de detección — Wazuh vs Suricata" — 45 min
- [ ] Redactar `docs/03_memoria_tfg/02_estado_arte.md` §2.6 "Amenazas en entornos post-explotación" — *fuentes: OWASP Top 10, MITRE ATT&CK* — 40 min
- [ ] Añadir referencias a `docs/03_memoria_tfg/99_bibliografia.md` — 10 min

---

### 2026-05-28 — EdA cierre + spec Escenario B arranque
- **Objetivo:** cerrar Estado del Arte y empezar especificación Escenario B
- **Presupuesto:** 1.5h
- **Plan:** `redactar_eda_v0` (cierre) + `spec_escenario_b` (arranque)
- [ ] Redactar `docs/03_memoria_tfg/02_estado_arte.md` §2.7 "Trabajos relacionados" — 30 min
- [ ] Releer EdA completo y marcar párrafos débiles con `[REVISAR]` sin reescribir — 20 min
- [ ] Crear `docs/01_investigacion/20260528_Prototipo_ZeroTrust.md` con cabecera y §1 "Objetivo" — 30 min

---

### 2026-05-29 — Spec Escenario B núcleo
- **Objetivo:** especificar la arquitectura Zero Trust completa
- **Presupuesto:** 1.5h
- **Plan:** `spec_escenario_b`
- [ ] Escribir `docs/01_investigacion/20260528_Prototipo_ZeroTrust.md` §2 "Topología — 3 redes Docker" con diagrama textual — 45 min
- [ ] Escribir §3 "mTLS webapp↔backend" — generación certs OpenSSL, proxy Caddy/Nginx — 30 min
- [ ] Escribir §4 "Wazuh mínimo" — 4 reglas para los hitos post-RCE, criterio fallback Falco — 20 min

---

### 2026-05-30 — Spec Escenario B cierre + revisión borrador completo
- **Objetivo:** cerrar spec y preparar paquete para el tutor
- **Presupuesto:** 1.5h
- **Plan:** `spec_escenario_b` (cierre) + preparación `email_tutor_31_05`
- [ ] Escribir `docs/01_investigacion/20260528_Prototipo_ZeroTrust.md` §5 "Requisitos de verificación" — cómo confirmar que los 4 hitos quedan bloqueados — 30 min
- [ ] Releer todos los MD de `docs/03_memoria_tfg/` y añadir `[REVISAR]` donde haya huecos — 30 min
- [ ] Preparar borrador del texto del email al tutor en un documento temporal — 30 min

---

### 2026-05-31 — ⚠️ EMAIL TUTOR
- **Objetivo:** enviar el borrador "razonablemente decente" al tutor
- **Presupuesto:** 2h
- **Plan:** `email_tutor_31_05`
- [ ] Exportar `docs/03_memoria_tfg/02_estado_arte.md` a PDF (Pandoc o copia en texto plano) — 20 min
- [ ] Componer email (ver plantilla en `docs/02_reuniones_tutor/00_DIRECTRICES_TUTOR.md §7`) — 30 min
- [ ] **ENVIAR el email al tutor antes de las 20:00** — índice 8 caps + EdA v0 + propuesta Escenario B + pregunta de validación — 5 min
- [ ] Registrar envío en `docs/02_reuniones_tutor/BITACORA_REUNIONES.md` — 10 min

---

## FASE 2 — SEMANA 2 (01/06–07/06) · 12h/día desde 02/06 · Objetivo: Escenario B funcional

---

### 2026-06-01 — Spec final + preparación implementación
- **Objetivo:** cerrar spec y tener el entorno listo para construir
- **Presupuesto:** 2h (último día baja intensidad)
- **Plan:** `implementar_escenario_b` (preparación)
- [ ] Revisar `docs/01_investigacion/20260528_Prototipo_ZeroTrust.md` — confirmar que cada decisión tiene criterio de verificación — 30 min
- [ ] Crear estructura de carpetas en `infra/zero_trust/` (vacías con `.gitkeep` por servicio) — 20 min
- [ ] Listar imágenes Docker necesarias y confirmar versiones — 20 min

---

### 2026-06-02 — ZT: docker-compose base + 3 redes
- **Objetivo:** docker-compose levanta con 3 redes aisladas y servicios separados
- **Presupuesto:** 12h
- **Plan:** `implementar_escenario_b`
- [ ] Escribir `infra/zero_trust/docker-compose.yaml` con `web_zone`, `backend_zone`, `db_zone` — 3h
- [ ] Copiar y adaptar servicios de `infra/perimetral/` (webapp, backend, db, nginx) — 2h
- [ ] Verificar que `webapp` NO puede hacer ping a `db` directamente — 1h
- [ ] Verificar que todos los servicios levantan healthy — 2h
- [ ] Documentar en `docs/04_diario_laboratorio/20260602_Sesion_ZT_DockerCompose.md` — 1h

---

### 2026-06-03 — ZT: mTLS webapp↔backend
- **Objetivo:** tráfico webapp→backend cifrado con mTLS verificado
- **Presupuesto:** 12h
- **Plan:** `implementar_escenario_b`
- [ ] Generar CA + cert servidor + cert cliente con OpenSSL — 1h
- [ ] Configurar Nginx/Caddy en `backend` para exigir cert cliente — 3h
- [ ] Configurar `webapp` para presentar cert cliente en llamadas a `backend` — 2h
- [ ] Verificar con `curl` y tcpdump que el tráfico es TLS — 2h (evidencia E3 Escenario B)
- [ ] Documentar en `docs/04_diario_laboratorio/20260603_Sesion_ZT_mTLS.md` — 1h

---

### 2026-06-04 — ⚠️ CHECKPOINT WAZUH 20:00
- **Objetivo:** Wazuh manager + agent en webapp con ≥1 alerta activa
- **Presupuesto:** 12h
- **Plan:** `implementar_escenario_b`
- [ ] Añadir `wazuh-manager` a `docker-compose.yaml` — 1h
- [ ] Enrollar Wazuh agent en contenedor `webapp` — 2h
- [ ] Crear regla custom de prueba (ej. detección de `env | grep DB_`) — 1h
- [ ] Verificar que el manager recibe eventos del agent — 2h
- **A las 20:00 — DECISIÓN BINARIA:**
  - Si manager + agent + ≥1 alerta → continuar mañana con reglas completas
  - Si no → `git stash` rama Wazuh, arrancar Falco (ver ADR en `admin/DECISIONS_LOG.md`)

---

### 2026-06-05 — ZT: reglas de detección para 4 hitos post-RCE
- **Objetivo:** los 4 hitos post-RCE de §1.2.b generan alerta o bloqueo
- **Presupuesto:** 12h
- **Plan:** `implementar_escenario_b`
- [ ] Regla 1: lectura de variables de entorno con credenciales DB (`env | grep DB_`) — 2h
- [ ] Regla 2: escaneo interno con nmap — 2h
- [ ] Regla 3: curl a `backend:5000/empleados` — 2h
- [ ] Regla 4: conexión a `db:5432` — 2h
- [ ] Verificar que cada regla genera evento en manager — 1h
- [ ] Documentar reglas en `docs/04_diario_laboratorio/20260605_Sesion_ZT_Reglas.md` — 1h

---

### 2026-06-06 — Pruebas A/B sesión 1 (post-RCE en ZT)
- **Objetivo:** ejecutar la cadena de ataque en Escenario B y capturar evidencias
- **Presupuesto:** 12h
- **Plan:** `ejecutar_pruebas_ab`
- [ ] Levantar Escenario B con `docker compose up --build -d` — 30 min
- [ ] Ejecutar cadena pre-RCE y registrar T0_efectivo — 1h
- [ ] Ejecutar los 4 hitos post-RCE y registrar qué se bloquea/detecta — 3h
- [ ] Capturar logs en `tests/logs/zerotrust_sesion_YYYYMMDD_HHMMSS/` — 1h
- [ ] Verificar que `lateral.pcap` muestra TLS o rechazo (E3) — 1h
- [ ] Rellenar `tests/00_PLANTILLA_KPI_v2.md §2` con valores reales — 2h

---

### 2026-06-07 — Pruebas A/B sesión 2 + cierre KPIs
- **Objetivo:** comparativa A vs B cerrada en plantilla
- **Presupuesto:** 12h
- **Plan:** `ejecutar_pruebas_ab`
- [ ] Segunda sesión de pruebas si la primera tuvo anomalías — 4h (si no → saltar)
- [ ] Rellenar `tests/00_PLANTILLA_KPI_v2.md §3` — tabla comparativa A vs B completa — 2h
- [ ] Hacer captura de pantalla de cada evidencia del Escenario B para Cap. 6 — 1h
- [ ] Documentar sesión en `docs/04_diario_laboratorio/20260607_Sesion_ZT_PruebasAB.md` — 1h

---

## FASE 3 — SEMANA 3 (08/06–14/06) · 12h/día · Objetivo: 60% memoria redactada

---

### 2026-06-08 — Cierre KPIs + arranque Cap. 6 Pruebas
- **Objetivo:** plantilla KPI v2 §2 y §3 cerrada; primeras secciones de Cap. 6 escritas
- **Presupuesto:** 12h
- **Plan:** `redactar_cap_3_4_5`
- [ ] Cerrar `tests/00_PLANTILLA_KPI_v2.md` §2 y §3 con todos los valores — 2h
- [ ] Redactar `docs/03_memoria_tfg/06_pruebas.md` §6.1 "Metodología de pruebas" — 2h
- [ ] Redactar §6.2 "Resultados Escenario A" (ya hay skeleton; completar texto a partir de plantilla) — 3h
- [ ] Redactar §6.3 "Resultados Escenario B" — 3h

---

### 2026-06-09 — Cap. 4 Diseño completo
- **Objetivo:** Cap. 4 Diseño cerrado en borrador
- **Presupuesto:** 12h
- **Plan:** `redactar_cap_3_4_5`
- [ ] Redactar `docs/03_memoria_tfg/04_diseno.md` §4.1-4.2 (visión general + Escenario A) — *insumo: `docs/01_investigacion/20260419_Prototipo_Red_Perimetral.md`* — 3h
- [ ] Redactar §4.3 "Escenario B Zero Trust" (principios, topología, mTLS, Wazuh, justif. Wazuh vs Suricata) — 4h
- [ ] Redactar §4.4 tabla tecnología y §4.5 limitaciones — 2h
- [ ] Primera pasada de coherencia del cap. completo — 1h

---

### 2026-06-10 — Cap. 6 comparativa + análisis cuantitativo
- **Objetivo:** §6.4 comparativa A vs B redactado — el corazón del TFG
- **Presupuesto:** 12h
- **Plan:** `redactar_cap_3_4_5`
- [ ] Redactar `docs/03_memoria_tfg/06_pruebas.md` §6.4.1 "Tabla comparativa final" (texto, no solo tabla) — 3h
- [ ] Redactar §6.4.2 "Análisis cuantitativo" — párrafo por métrica con mecanismo ZT explicado — 4h
- [ ] Redactar §6.4.3 "Casos sin mejora o degradación" — honestidad intelectual — 2h
- [ ] Primera pasada de coherencia Cap. 6 completo — 1h

---

### 2026-06-11 — Cap. 6 figuras + Cap. 3 Análisis del Problema
- **Objetivo:** Cap. 6 cerrado; Cap. 3 en borrador avanzado
- **Presupuesto:** 12h
- **Plan:** `redactar_cap_3_4_5`
- [ ] Insertar todos los `[FIG:]` de Cap. 6 como imágenes reales o Mermaid — 2h
- [ ] Cerrar Cap. 6 con primera pasada de revisión — 1h
- [ ] Redactar `docs/03_memoria_tfg/03_analisis_problema.md` §3.1 y §3.2 (texto narrativo, el skeleton ya tiene las tablas) — 3h
- [ ] Redactar §3.3 requisitos y §3.4 KPIs en prosa explicativa — 3h

---

### 2026-06-12 — Cap. 5 Desarrollo e Implantación
- **Objetivo:** Cap. 5 en borrador — decisiones de implementación documentadas
- **Presupuesto:** 12h
- **Plan:** `redactar_cap_3_4_5`
- [ ] Redactar `docs/03_memoria_tfg/05_desarrollo_implantacion.md` §5.1-5.2 (IaC + Escenario A) — *insumo: diarios `docs/04_diario_laboratorio/`* — 3h
- [ ] Redactar §5.3 "Escenario B" (completar los `[TODO POST-IMPL]` con lo implementado) — 4h
- [ ] Redactar §5.4 "Problemas de integración" (3-5 casos reales, honestos) — 2h
- [ ] Mover configuraciones extensas a `[Anexo: ver ...`] sin copiarlas en el cuerpo — 1h

---

### 2026-06-13 — Buffer + repaso caps 3/4/5/6
- **Objetivo:** los 4 capítulos centrales sin huecos sin rellenar
- **Presupuesto:** 12h
- [ ] Revisar caps. 3, 4, 5, 6 buscando `[TODO]` y `[TODO POST-IMPL]` sin resolver — 2h
- [ ] Resolver todos los `[TODO]` pendientes que no requieran datos del lab — 4h
- [ ] Añadir `[CITAR:]` inline a cada dato técnico sin referencia aún — 2h
- [ ] Revisar coherencia de numeración de secciones y referencias cruzadas — 1h
- [ ] Preparar lista de figuras que hay que crear para Overleaf (doc temporal) — 1h

---

### 2026-06-14 — ⚠️ CHECKPOINT OVERLEAF + EMAIL TUTOR
- **Objetivo:** Overleaf compila; email tutor con memoria al 60-70%
- **Presupuesto:** 8h
- **Plan:** `setup_overleaf` + `envio_tutor_14_06`
- [ ] Crear proyecto Overleaf con plantilla ETSINF UPV — cargar texto dummy y verificar que compila — 2h
- [ ] Componer email al tutor con caps. 3, 4, 5, 6 en borrador adjuntos como PDF — 1h
- [ ] **ENVIAR email al tutor** (ver plantilla `docs/02_reuniones_tutor/00_DIRECTRICES_TUTOR.md §7`) — 5 min
- [ ] Registrar en `docs/02_reuniones_tutor/BITACORA_REUNIONES.md` — 15 min

---

## FASE 4 — SEMANA 4 (15/06–21/06) · 12h/día · Objetivo: memoria completa y depositada

---

### 2026-06-15 — Cap. 1 Introducción
- **Objetivo:** Cap. 1 cerrado en borrador
- **Presupuesto:** 12h
- **Plan:** `redactar_intro_conclusiones`
- [ ] Redactar `docs/03_memoria_tfg/01_intro.md` §1.1 "Motivación" — gancho Endesa + estadística coste ciberdelincuencia — 2h
- [ ] Redactar §1.2 "Objetivos" — revisitar skeleton y convertir bullets en prosa — 2h
- [ ] Redactar §1.3 "Estructura de la memoria" — un párrafo por capítulo — 1h
- [ ] Primera pasada completa del Cap. 1 — 1h

---

### 2026-06-16 — Cap. 7 Conclusiones
- **Objetivo:** Cap. 7 cerrado en borrador
- **Presupuesto:** 12h
- **Plan:** `redactar_intro_conclusiones`
- [ ] Redactar `docs/03_memoria_tfg/07_conclusiones.md` §7.1 "Conclusiones" — responder la hipótesis con datos reales de Cap. 6 — 3h
- [ ] Redactar §7.2 "Limitaciones" — honestas y concretas — 2h
- [ ] Redactar §7.3 "Trabajo futuro" — Suricata, K8s, mTLS completo, SOAR — 2h
- [ ] Retocar `docs/03_memoria_tfg/00_resumen.md` con ajustes cosméticos finales — 1h

---

### 2026-06-17 — Overleaf: EdA + Caps 3 y 4
- **Objetivo:** tres capítulos transferidos y compilando en Overleaf
- **Presupuesto:** 12h
- **Plan:** `transferir_a_overleaf`
- [ ] Transferir Cap. 2 (Estado del Arte) a Overleaf — 2h
- [ ] Transferir Cap. 3 (Análisis del Problema) a Overleaf — 2h
- [ ] Transferir Cap. 4 (Diseño) a Overleaf — 2h
- [ ] Crear entradas BibTeX en Overleaf para todas las referencias de `99_bibliografia.md` — 2h
- [ ] Verificar compilación sin errores — 1h

---

### 2026-06-18 — Overleaf: Caps 5, 6, 7 + figuras
- **Objetivo:** memoria completa en Overleaf compilando
- **Presupuesto:** 12h
- **Plan:** `transferir_a_overleaf`
- [ ] Transferir Caps 5, 6, 7 y abstract a Overleaf — 3h
- [ ] Crear y subir todas las figuras de la lista preparada el 13/06 — 3h
- [ ] Maquetar tablas KPI, código, capturas de pantalla — 2h
- [ ] Resolver todos los errores LaTeX — 2h
- [ ] Verificar índice, paginación, portada — 1h

---

### 2026-06-19 — ⚠️ REVISIÓN FINAL + EMAIL TUTOR
- **Objetivo:** PDF final al tutor con margen de 48h para correcciones
- **Presupuesto:** 12h
- **Plan:** `envio_tutor_19_06`
- [ ] Revisión pasada 1: ortografía y gramática — 2h
- [ ] Revisión pasada 1: coherencia narrativa y referencias cruzadas — 2h
- [ ] Revisión pasada 1: todas las citas `[CITAR:]` convertidas a BibTeX — 2h
- [ ] Generar PDF desde Overleaf y revisar visualmente — 1h
- [ ] **ENVIAR email al tutor con PDF adjunto** — 5 min
- [ ] Registrar en `docs/02_reuniones_tutor/BITACORA_REUNIONES.md` — 10 min

---

### 2026-06-20 — Correcciones del tutor + revisión pasada 2
- **Objetivo:** incorporar feedback del tutor; segunda pasada de revisión propia
- **Presupuesto:** 10h
- **Plan:** `revision_final_entrega`
- [ ] Incorporar correcciones del tutor (si llegaron) — hasta 3h
- [ ] Revisión pasada 2: formato ETSINF — márgenes, portada, numeración — 2h
- [ ] Revisión pasada 2: figuras, títulos de tablas, leyendas — 1h
- [ ] Revisión pasada 2: bibliografía completa y con fechas de acceso — 1h
- [ ] Generar PDF candidato final y guardar en local — 30 min

---

### 2026-06-21 — ⚠️ ENTREGA
- **Objetivo:** PDF depositado en plataforma antes del cierre
- **Presupuesto:** 6h + 4-5h buffer
- **Plan:** `revision_final_entrega`
- [ ] Revisión pasada 3 rápida — leer el PDF de portada a contraportada — 2h
- [ ] Correcciones finales de último minuto en Overleaf — 1h
- [ ] Generar PDF definitivo — 15 min
- [ ] **DEPOSITAR en la plataforma de la ETSINF** — 30 min
- [ ] Registrar entrega en `admin/STATE.md` y `docs/02_reuniones_tutor/BITACORA_REUNIONES.md` — 15 min

---

## REGLAS DE USO DE ESTA AGENDA

1. **Cada mañana:** sobrescribir `admin/HOY.md` con el día actual (copiar el bloque del día desde aquí).
2. **Si una tarea se retrasa:** no mover al día siguiente. Reducir su alcance para cerrarla hoy.
3. **Si un día entero se pierde:** el buffer del plan absorbe hasta 2 días. A partir del 3.º, valorar Plan C.
4. **Regla anti-parálisis:** si llevas 20 min bloqueado en un párrafo, escríbelo en bullets y sigue. Vuelve al final.
5. **Regla de no perfeccionismo:** un `[REVISAR]` inline es mejor que no avanzar. Las revisiones van en bloque.
