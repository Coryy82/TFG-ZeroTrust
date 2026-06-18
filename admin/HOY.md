# HOY — 2026-06-18 (jueves) · OVERLEAF COMPLETO + FIGURAS

> **Situación:** Fase 4 — Semana 4 · **Penúltimo día antes del hito 19/06.**
> **Completado 16–17/06:** email tutor ✅ (caps. 2–6) · Cap. 1 ✅ · Cap. 7 ✅ · plantilla `.tex` local ✅ (commit `aa1d73c`).
> **Deuda arrastrada:** `setup_overleaf` online sin iniciar · transferencia MD→Overleaf incompleta · ~32 `[FIG:]` sin resolver · PDF no compilado.
> **Bloqueo activo:** respuesta del tutor pendiente (email 16/06; 48h+ vencidas). **No bloquear el día esperando feedback.**
> Plan IDs: `setup_overleaf` → `transferir_a_overleaf` → `cerrar_cap_4_5_figuras`
> Fase: 4 de 4 · **Próximo hito duro mañana 19/06:** PDF compilado + email final al tutor.

---

## OBJETIVO DEL DÍA

1. **Crear proyecto Overleaf online** con plantilla ETSINF y verificar que compila (arrancar desde `borradorplantillatfgoverleaf.tex` si acelera).
2. **Transferir memoria completa:** Caps. 1–7 + resumen/abstract + BibTeX desde `99_bibliografia.md`.
3. **Figuras mínimas:** insertar 4–6 capturas clave (Cap. 6 prioritario; resto placeholder o anexo).
4. **Generar PDF descargable** listo para revisión final mañana y envío al tutor el 19/06.

---

## SI SOLO HACES UNA COSA

**Consigue un PDF que compile en Overleaf con los 7 capítulos**, aunque falten figuras secundarias o queden placeholders. Mañana toca revisión ortográfica + email final; hoy el cuello de botella es la compilación, no la perfección editorial.

---

## CONTEXTO: QUÉ CAMBIÓ DESDE EL 14/06

| Tema | Estado 14/06 | Estado actual (18/06) |
|------|--------------|------------------------|
| Cap. 3–6 texto | ✅ [HUMANO] | ✅ Sin cambios sustanciales |
| Cap. 4 §4.5 + skeleton | ❌ Pendiente | ✅ Cerrado (commit `3ff326b`) |
| Cap. 1 §1.1–§1.5 | ❌ Pendiente | ✅ Borrador [HUMANO] (17/06; commits `3d65bc0`, `684a809`) |
| Cap. 7 §7.1–§7.4 | ❌ Pendiente (agenda 16/06) | ✅ Borrador [HUMANO] (17/06); pendiente revisión estilo §7 |
| Email tutor caps. 2–6 | ❌ Pendiente | ✅ Enviado **16/06** (timeline §19, bitácora) |
| Respuesta tutor | — | ❌ Sin respuesta a 18/06 (duda §5.4 sin resolver) |
| Plantilla LaTeX local | ❌ | ✅ `borradorplantillatfgoverleaf.tex` ~780 líneas (`aa1d73c`) |
| Overleaf online | ❌ | ❌ `setup_overleaf` sin iniciar |
| PDF compilado | ❌ | ❌ Pendiente |
| Figuras `[FIG:]` | ~32 sin resolver | ~32 sin resolver (Cap. 5: 16 · Cap. 6: 10 · Cap. 4: 5) |
| Hito 19/06 | 5 días | **MAÑANA** |

**Commits recientes (referencia):**

- `3ff326b` (14/06): Cap. 4 §4.4.1–§4.5 cerrados; skeleton eliminado
- `aa1d73c` (17/06): plantilla Overleaf local ETSINF con caps. 2–6
- `3d65bc0`, `684a809` (17/06): Caps. 1 y 7 en borrador
- `735133a` (17/06): refinamiento Cap. 6 §6

**Artefacto base Overleaf:** `docs/03_memoria_tfg/Borradores y pretrabajos/borradorplantillatfgoverleaf.tex`

**Fuentes para figuras prioritarias (evidencias ya capturadas):**

- `tests/logs/perimetral_sesion_20260523_175204/` — nmap, lateral.pcap, creds, SQL
- `tests/logs/zerotrust_sesion_20260609_130120/` — nmap ZT, lateral_attempt.log, alerts
- Plantilla KPI: `tests/00_PLANTILLA_KPI_v2.md` §1–§3

**Plan B si el tutor no responde hoy:** avanzar con PDF completo mañana 19/06; incorporar feedback solo si llega antes del depósito del 21/06.

---

## PENDIENTES ARRASTRADOS (14–17/06)

Prioridad antes del PDF de mañana:

| ID | Tarea | Origen | Tiempo est. |
|----|-------|--------|-------------|
| P1 | Crear proyecto Overleaf online + verificar compilación dummy | Agenda 14/06, STATE | 1h |
| P2 | Subir/integrar `borradorplantillatfgoverleaf.tex` + Caps. 1 y 7 (no iban en email 16/06) | Agenda 17–18/06 | 2h |
| P3 | BibTeX desde `99_bibliografia.md` | Agenda 17/06 | 1h30 |
| P4 | Figuras clave Cap. 6: nmap-perimetral, nmap-zerotrust, lateral 400, alertas Wazuh | Agenda 18/06 | 1h30 |
| P5 | Resolver errores LaTeX hasta PDF descargable | Agenda 18/06 | 2h |
| P6 | Verificar portada, índice, paginación, resumen | Agenda 18/06 | 45 min |
| P7 | Crear `admin/reportes/reporte_2026-06-18.md` al cierre | Admin | 15 min |

**Puede esperar al 19/06 (revisión final):**

- 16 `[FIG:]` restantes Cap. 5 (salvo 1–2 de arquitectura si sobra tiempo)
- Revisión estilo Cap. 7 `[IA - REVISAR]`
- Conversión masiva `[CITAR:]` → BibTeX inline
- Decisión editorial §5.4 (esperar tutor; si no responde, mantener en Cap. 5 con nota o mover a anexo)
- Anexos de configuración Cap. 5

---

## BLOQUES DE TRABAJO

### Bloque 0 — 15 min · Alineación

- Leer `admin/STATE.md` (actualizado 18/06)
- Confirmar: sin tareas de laboratorio pendientes
- Decisión del día: **Overleaf online es la prioridad absoluta** — el `.tex` local es punto de partida, no sustituto de compilación verificada

---

### Bloque 1 — 1h · Setup Overleaf (`setup_overleaf`) — PRIORIDAD

- Crear proyecto Overleaf con plantilla ETSINF UPV
- Subir `borradorplantillatfgoverleaf.tex` como base (ya contiene caps. 2–6)
- Verificar compilación con texto dummy o primer capítulo
- Resolver errores de clase/paquetes antes de seguir

**Hecho cuando:** proyecto online compila sin error fatal.

---

### Bloque 2 — 3h · Transferencia completa (`transferir_a_overleaf`)

**Caps. pendientes respecto al email del 16/06:**

- Cap. 1 (`01_intro.md`) — no iba en el adjunto
- Cap. 7 (`07_conclusiones.md`) — redactado el 17/06
- `00_resumen.md` — abstract/resumen

**Revisión de caps. ya en plantilla:**

- Cap. 2 EdA — verificar contra `02_estado_arte.md`
- Caps. 3–6 — sincronizar con MD fuente por si hubo commits posteriores (`735133a`, `3ff326b`)

**BibTeX:**

- Crear entradas desde `99_bibliografia.md`
- Sustituir referencias críticas inline (mínimo las del Cap. 6 §6.4)

**Hecho cuando:** los 7 capítulos + resumen están en Overleaf y el documento compila (aunque con warnings).

---

### Bloque 3 — 2h · Figuras mínimas (`cerrar_cap_4_5_figuras`)

Insertar solo las imprescindibles para que el PDF sea legible y demuestre resultados:

1. `[FIG: nmap-zerotrust]` — escaneo reducido Escenario B
2. `[FIG: lateral_attempt.log — 400 sin certificado]` — bloqueo mTLS
3. `[FIG: nmap-perimetral]` — contraste visibilidad red plana
4. Tabla comparativa KPI §6.4 (si no está ya maquetada)
5. *(Opcional)* alerta Wazuh T1046/T1552.004
6. *(Opcional)* 1 diagrama arquitectura A/B del Cap. 4

El resto de `[FIG:]` puede quedar como placeholder `[Figura pendiente — Anexo X]` sin bloquear compilación.

**Hecho cuando:** al menos 4 figuras reales insertadas; PDF visualmente coherente en Cap. 6.

---

### Bloque 4 — 2h · Compilación y pulido LaTeX

- Resolver errores LaTeX uno a uno (timebox 20 min/error; si supera → simplificar)
- Maquetar tablas KPI y bloques de código críticos
- Verificar índice generado, numeración de secciones, portada ETSINF
- Generar y **descargar PDF**
- Lectura visual rápida: saltos de página groseros, títulos huérfanos, referencias rotas

**Hecho cuando:** PDF descargable con memoria completa caps. 1–7.

---

### Bloque 5 — 45 min · Preparación hito 19/06

Solo si los bloques 1–4 terminan antes de las 20:00:

- Esbozar email final al tutor (`envio_tutor_19_06`) — plantilla `docs/02_reuniones_tutor/00_DIRECTRICES_TUTOR.md` §7
- Lista de `[CITAR:]` / typos detectados en la lectura visual → backlog revisión mañana
- Si llega respuesta del tutor hoy: anotar feedback en bitácora; aplicar solo cambios rápidos (<30 min)

**Hecho cuando:** PDF guardado localmente + borrador mental del email de mañana.

---

## NO HACER HOY

- **No** repetir sesión de laboratorio (KPI y evidencias cerradas 09/06).
- **No** reabrir texto de caps. 1–7 salvo error que impida compilar (typos LaTeX, no reescritura editorial).
- **No** insertar las 32 figuras — priorizar 4–6 clave.
- **No** bloquear el día esperando respuesta del tutor (48h+ ya vencidas).
- **No** perseguir perfección BibTeX — citas críticas primero; resto mañana.
- **No** reabrir §6.4 salvo typo que invalide la comparativa cuantitativa.

---

## CRITERIO DE ÉXITO MÍNIMO DEL DÍA

- Proyecto Overleaf online **compila**
- PDF descargable con **caps. 1–7 + resumen**
- Al menos **4 figuras reales** en Cap. 6 (o mix Cap. 4/6)

**Mínimo absoluto (si el día se acorta):** Overleaf compila + PDF con caps. 1–7 aunque falten la mayoría de figuras. La revisión ortográfica y el email son tarea del **19/06**.

**Stretch (día completo 8–10h):** todo lo anterior + BibTeX mayoritario + 6 figuras + portada/índice verificados + borrador email tutor listo.

---

## CIERRE

Al terminar:

1. Actualizar `admin/STATE.md`: mover `setup_overleaf` y avance de `transferir_a_overleaf` a DONE si aplica; actualizar riesgo hito 19/06.
2. Crear `admin/reportes/reporte_2026-06-18.md`.
3. Commit si hay cambios en `.tex`, figuras o caps.: «docs: Overleaf caps. 1–7 + figuras mínimas Cap. 6» (si procede).
4. **Mañana 19/06 (agenda):** revisión ortográfica + coherencia + `[CITAR:]` críticos → **ENVIAR PDF final al tutor** → registrar en bitácora.
5. Recordatorio: **21/06** — depósito en plataforma · margen correcciones tutor: 48h desde email del 19/06.
