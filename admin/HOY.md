# HOY — 2026-06-08 (domingo) · ⚠️ RECUPERAR PRUEBAS A/B + ARRANQUE CAP. 6 + PREPARAR TUTOR

> **Situación:** Fase 3 — Semana 3. El índice anotado ya está enviado y validado (06/06). El stack ZT + Wazuh está operativo desde el 04/06. **Bloqueo activo:** `ejecutar_pruebas_ab` no se ejecutó en la ventana 06–07/06 — no hay `tests/logs/zerotrust_sesion_*` ni KPIs §2/§3 rellenados. El hito del **09/06** (KPIs cerrados) está en riesgo.
> Plan IDs: `ejecutar_pruebas_ab` (recuperación) → `redactar_cap_3_4_5` → `preparar_reunion_tutor`
> Fase: 3 de 4 · Semana 3 · **Deadline duro mañana 09/06:** KPIs §2/§3 cerrados.

---

## OBJETIVO DEL DÍA

1. **Desbloquear la línea crítica:** ejecutar la sesión formal de pruebas A/B en Escenario B, capturar evidencias y cerrar `tests/00_PLANTILLA_KPI_v2.md` §2 y §3.
2. **Arrancar el corazón del TFG:** redactar las primeras secciones de `06_pruebas.md` (§6.1–§6.3) con los datos capturados.
3. **Preparar la reunión con el tutor:** el tutor pidió cita en despacho cuando haya contenido redactado. Hoy toca preparar el material (objetivos reformulados, extracto de pruebas, preguntas) y, si los KPIs quedan cerrados, solicitar la cita.

---

## SI SOLO HACES UNA COSA

Ejecuta la cadena post-RCE completa en Escenario B, captura los logs en `tests/logs/zerotrust_sesion_YYYYMMDD_HHMMSS/` y rellena al menos `tests/00_PLANTILLA_KPI_v2.md` §2. Sin eso no hay Cap. 6 ni comparativa cuantitativa.

---

## CONTEXTO: QUÉ DIJO EL TUTOR (06/06)

Del correo **§18** en `docs/02_reuniones_tutor/00_TIMELINE_CORREOS.md`:

- **Luz verde general:** puede avanzar hacia la memoria.
- **Matiz crítico:** el objetivo no es solo *"comparar dos arquitecturas"* — debe **responder a una pregunta clave**. *"Vender la cabra"*: problema → hipótesis → diseño → pruebas → respuesta.
- **Próximo contacto:** *"cuando tengas contenido quedamos un día en mi despacho"* — alineado con memoria ~60–70% (hito 14/06), pero conviene ir preparando el dossier hoy.

**Pregunta de investigación (ADR 2026-06-06, borrador):**
> *¿En qué medida una arquitectura Zero Trust con microsegmentación e identidad de servicio reduce el impacto de ataques post-explotación frente a un modelo perimetral en infraestructuras contenerizadas?*

---

## BLOQUES DE TRABAJO

### Bloque 0 — 5h · Recuperación: pruebas A/B formales (`ejecutar_pruebas_ab`)

**Prioridad máxima.** Recupera las tareas vencidas del 06–07/06 antes de redactar.

**Pre-vuelo (15 min):**
```bash
cd infra/zero_trust
docker compose up --build -d
docker compose ps   # todos healthy
```

**Sesión formal Escenario B:**
- [ ] Ejecutar cadena pre-RCE (recon → info disclosure → login → SSTI → RCE) — 1h
- [ ] Registrar `T0_efectivo` con timestamp visible — 15 min
- [ ] Ejecutar los 4 hitos post-RCE y anotar bloqueo/detección — 2h
  1. `env | grep DB_` → exfiltración creds (`T_exfil_creds`)
  2. `nmap` escaneo interno (`T_scan`)
  3. `curl` a `backend:5000/empleados` con `tcpdump` (`T_lateral`, `T_e3_pcap`)
  4. Conexión directa `webapp → db:5432` (`T_objetivo`)
- [ ] Capturar logs en `tests/logs/zerotrust_sesion_YYYYMMDD_HHMMSS/` — 1h
- [ ] Verificar `lateral.pcap`: TLS o rechazo mTLS (evidencia E3) — 30 min
- [ ] Documentar sesión en `docs/04_diario_laboratorio/20260608_Sesion_ZT_PruebasAB.md` — 45 min

**Verificaciones Wazuh pendientes (integrar en la sesión, no como bloque aparte):**
```bash
# Regla env | grep DB_
docker exec zero_trust-webapp-1 env | grep -i db
docker exec wazuh-wazuh-manager-1 tail -50 /var/ossec/logs/alerts/alerts.json | grep -i "env\|DB_\|credential"

# Bloqueo microsegmentación webapp → db:5432
docker exec zero_trust-webapp-1 nc -zv db 5432
```

- [ ] Confirmar alerta o ausencia documentada para `env | grep`
- [ ] Confirmar bloqueo de red para `db:5432` (evidencia G3/E1, no requiere regla Wazuh)

**Hecho cuando:** existe carpeta `zerotrust_sesion_*` con logs, pcap, creds y cronología anotada.

---

### Bloque 1 — 2h · Cierre KPIs (`ejecutar_pruebas_ab` + agenda 08/06)

- [ ] Rellenar `tests/00_PLANTILLA_KPI_v2.md` §2 (Escenario B) con valores reales — 1h
- [ ] Rellenar `tests/00_PLANTILLA_KPI_v2.md` §3 (tabla comparativa A vs B) — 1h
- [ ] Hacer capturas de pantalla de evidencias clave para Cap. 6 — 30 min (si queda tiempo en el bloque)

**Hecho cuando:** §2 y §3 de la plantilla KPI v2 tienen todos los campos rellenados (G1–G3, E1–E3, timings §2.2.b, denominador 4 hitos).

---

### Bloque 2 — 3h · Arranque Cap. 6 Pruebas (`redactar_cap_3_4_5`)

Solo después de tener datos del Bloque 0–1. Fuentes: plantilla KPI v2 §1 (A, ya completo) + §2/§3 (recién cerrados).

- [ ] Redactar `docs/03_memoria_tfg/06_pruebas.md` §6.1 "Metodología de pruebas" — 1h
- [ ] Redactar §6.2 "Resultados Escenario A" (completar texto a partir de plantilla §1) — 1h
- [ ] Redactar §6.3 "Resultados Escenario B" con datos de hoy — 1h

**Hecho cuando:** §6.1–§6.3 tienen prosa redactada (no solo `[TODO]`), con tablas y referencias a rutas de evidencia.

---

### Bloque 3 — 1.5h · Preparar reunión con el tutor (`preparar_reunion_tutor`)

El tutor no exige la cita hoy, pero hay que tener el material listo para solicitarla en cuanto el Cap. 6 tenga borrador sustancial.

**Documentos a preparar:**
- [ ] Actualizar §1.2 del índice anotado con la pregunta de investigación (ADR 2026-06-06) — 20 min
  - Archivo: `docs/03_memoria_tfg/Borradores y pretrabajos/Borrador_Indice_Anotado_HUMANO.md`
  - Corregir typos pendientes: *preubas* → *pruebas* (§7.1), *Los 6 métricas* → *Las 6 métricas* (§3.4)
- [ ] Redactar borrador de §1.2 Objetivos para `01_intro.md` (pregunta + hipótesis + método comparativo) — 30 min
- [ ] Preparar dossier de reunión (1–2 páginas) — 30 min
  - Pregunta de investigación propuesta
  - Extracto EdA §2.1–§2.6 (ya redactado)
  - Tabla KPI §3 (si Bloque 1 cerrado) o resumen cualitativo provisional
  - Borrador §6.1–§6.3 (si Bloque 2 avanzado)
  - Lista de 3–5 preguntas concretas para el tutor
- [ ] Borrador de email para solicitar cita en despacho — 15 min
  - Asunto sugerido: `TFG — Solicitud cita despacho: borrador pruebas + objetivos reformulados`
  - Adjuntar o pegar: dossier + índice actualizado
  - Pedir feedback sobre: formulación de objetivos, profundidad Cap. 6, coherencia narrativa problema→solución

**Preguntas sugeridas para el tutor:**
1. ¿La pregunta de investigación propuesta articula bien el problema y la contribución?
2. ¿El nivel de detalle previsto en Cap. 6 (tabla KPI + análisis por métrica) es el adecuado?
3. ¿El SIEM como mecanismo auxiliar de G1/G3 queda bien delimitado frente al núcleo (segmentación + mTLS)?
4. ¿Conviene adelantar la cita antes del 14/06 o esperar al envío del 60–70%?

**Hecho cuando:** tienes dossier + email borrador listos para enviar en cuanto §6.3 esté redactado (hoy tarde o mañana temprano).

---

### Bloque 4 (opcional, 30 min) · Cerrar §2.7 EdA (`redactar_eda_v0`)

Solo si los bloques 0–2 están cerrados o bloqueados por un problema técnico >2h.

- [ ] Redactar §2.7 "Trabajos relacionados" en `docs/03_memoria_tfg/02_estado_arte.md` — 30 min
  - Fuentes locales: Jiménez (UPM ZT), Vico (SIEM), Torregrosa (acceso remoto), Pérez/G6508
  - 2–3 párrafos: posicionar este TFG frente a trabajos similares (comparativa A/B cuantitativa, no despliegue SIEM)

---

## NO HACER HOY

- No redactar Cap. 4 Diseño completo (eso es mañana 09/06 según agenda).
- No abrir Overleaf ni maquetar LaTeX (hito 14/06).
- No reabrir `infra/zero_trust/` salvo fallo bloqueante en las pruebas (timeboxing 2h → documentar y seguir).
- No esperar respuesta del tutor para ejecutar las pruebas — la línea crítica es laboratorio, no correo.
- No perfeccionar §2.7 si las pruebas A/B siguen sin ejecutar.

---

## CRITERIO DE ÉXITO MÍNIMO DEL DÍA

El día es exitoso si al terminar puedes marcar esto:

- [ ] Sesión formal Escenario B ejecutada con logs en `tests/logs/zerotrust_sesion_*`
- [ ] `tests/00_PLANTILLA_KPI_v2.md` §2 y §3 cerrados con valores reales
- [ ] `06_pruebas.md` §6.1–§6.3 con borrador redactado (aunque sea primera pasada)
- [ ] Dossier de reunión tutor preparado + email borrador para solicitar cita
- [ ] §1.2 objetivos reformulados como pregunta de investigación (índice o `01_intro.md`)

**Mínimo absoluto (si el día se acorta):** pruebas ejecutadas + §2 KPI rellenado. El resto pasa a mañana 09/06 con prioridad.

---

## CIERRE

Al terminar:
1. Actualiza `admin/STATE.md`: mueve tareas completadas; si §2/§3 cerrados, marca progreso en `ejecutar_pruebas_ab`.
2. Si enviaste solicitud de cita al tutor: regístrala en `docs/02_reuniones_tutor/BITACORA_REUNIONES.md`.
3. **Hito mañana 09/06:** KPIs §2/§3 cerrados + Escenario B verificado. Si hoy no cierras §3, mañana es solo laboratorio + KPI, sin Cap. 4.
4. **Hito 14/06 en 6 días:** memoria 60–70% + email tutor. La reunión en despacho alimenta ese envío.
5. Mañana (09/06): copiar el bloque `### 2026-06-09` de `AGENDA_SPRINT_DIARIA.md` en este archivo.
