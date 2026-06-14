# HOY — 2026-06-14 (domingo) · CHECKPOINT OVERLEAF + EMAIL TUTOR

> **Situación:** Fase 3 — Semana 3 · **Último día del hito 14/06.**
> **Completado 12/06:** Cap. 3 ✅ · Cap. 5 ✅ · Cap. 6 texto ✅ (commits `381658a`, `d7c30db`, `57c08d6`).
> **Deuda 13/06 (buffer no ejecutado):** §4.5 sin cerrar · 12 `[TODO]` residuales en Cap. 4 · figuras Caps. 5–6 sin insertar · repaso `[CITAR:]` / coherencia cruzada · `reporte_2026-06-12.md` sin crear.
> **Bloqueo activo:** `setup_overleaf` y `envio_tutor_14_06` pendientes — **hoy es el día del hito.**
> Plan IDs: `cerrar_cap_4_5_figuras` → `setup_overleaf` → `envio_tutor_14_06`
> Fase: 3 de 4 · **Próximo hito duro 16/06:** Caps. 1 y 7 en borrador.

---

## OBJETIVO DEL DÍA

1. **Cerrar deuda Cap. 4:** §4.5 limitaciones + eliminar `[TODO]` skeleton redundantes (la prosa [IA/HUMANO] ya cubre §4.1–4.3); cerrar §4.4.1 con frase de cierre.
2. **Figuras mínimas:** insertar 3–4 capturas clave en Cap. 6 (nmap ZT, lateral 400, opcional tshark A) — el resto puede quedar `[FIG:]` para Fase 4.
3. **Checkpoint ROADMAP:** crear proyecto Overleaf (plantilla ETSINF, compila con dummy) + generar PDF borrador Caps. 3–6.
4. **Enviar email al tutor** con memoria ~60–70% y registrar en bitácora.

---

## SI SOLO HACES UNA COSA

**Envía el email al tutor** con un PDF que incluya Caps. 3, 4, 5 y 6 en borrador. Aunque falten figuras o queden `[TODO]` menores en Cap. 4, el núcleo cuantitativo (Cap. 6 §6.4) y el hilo problema→diseño→implantación→pruebas ya están redactados. Overleaf puede quedar en esbozo si el PDF se genera por otra vía (pandoc, export MD, etc.).

---

## CONTEXTO: QUÉ CAMBIÓ DESDE EL 12/06

| Tema | Estado 12/06 | Estado actual (14/06) |
|------|--------------|------------------------|
| Cap. 3 §3.1–§3.4 | ✅ [HUMANO] | ✅ Revisión humana hecha; pendiente alinear pregunta con §1.2 (Fase 4) |
| Cap. 5 §5.1–§5.5 | ✅ [HUMANO] | ✅ Texto completo; 16 `[FIG:]` sin resolver (no bloquean envío) |
| Cap. 6 §6.1–§6.4 | ✅ [HUMANO] | ✅ Texto completo; ~8 `[FIG:]` sin resolver |
| Cap. 4 §4.1–§4.3 | Prosa [IA/HUMANO] | ⚠️ Prosa OK pero **12 `[TODO]` skeleton** sin borrar encima del texto |
| Cap. 4 §4.4.1 | Bullets + 2 `[TODO]` | ⚠️ Falta frase de cierre |
| Cap. 4 §4.5 | Texto [IA] + `[TODO]` esqueleto | ❌ **Pendiente — deuda 12/13/06** |
| Buffer 13/06 | Planificado | ❌ No ejecutado (sin commits ni reporte) |
| Overleaf | — | ❌ `setup_overleaf` sin iniciar |
| Email tutor 14/06 | — | ❌ `envio_tutor_14_06` pendiente |
| Cap. 1 §1.2 | Opcional 12/06 | ❌ Pendiente (agenda 15/06) |
| Hito 14/06 | 2 días | **HOY** |

**Commits recientes (referencia):**

- `381658a` (12/06): Cap. 3 — modelo amenazas, RF/RNF, KPIs
- `d7c30db` (12/06): Cap. 5 — IaC, escenarios A/B, integración
- `57c08d6` (12/06): Cap. 6 §6.4 comparativa + revisiones editoriales
- `0651569`: skill redactar-memoria-tfg
- `3bfd789`: directrices editoriales + perfil autor

**Fuentes para figuras Cap. 6 (evidencias ya capturadas):**

- `tests/logs/perimetral_sesion_20260523_175204/` — nmap, lateral.pcap, creds, SQL
- `tests/logs/zerotrust_sesion_20260609_130120/` — nmap ZT, lateral_attempt.log, alerts
- Plantilla: `tests/00_PLANTILLA_KPI_v2.md` §1–§3 (rutas verificadas)

**Plantilla email tutor:** `docs/02_reuniones_tutor/00_DIRECTRICES_TUTOR.md` §7 — breve, bullets: (1) qué entregas, (2) qué pides (revisión núcleo cuantitativo), (3) qué harás si no responde en 48h.

---

## PENDIENTES ARRASTRADOS (12–13/06)

Prioridad antes del envío al tutor:

| ID | Tarea | Origen | Tiempo est. |
|----|-------|--------|-------------|
| P1 | Cerrar §4.5: borrar `[TODO]` esqueleto; conservar texto [IA] (3 párrafos) | HOY 12/06 Bloque 3 | 20 min |
| P2 | Limpiar Cap. 4: eliminar los 12 `[TODO]` de §4.1–4.3 donde ya hay prosa [IA] debajo | Agenda 13/06 | 45 min |
| P3 | §4.4.1: redactar 1 frase de cierre; borrar `[TODO]` restantes | Agenda 13/06 | 15 min |
| P4 | Figuras mínimas Cap. 6: nmap-perimetral, nmap-zerotrust, lateral 400, opcional tshark | HOY 12/06 Bloque 3 | 1h |
| P5 | Repaso rápido: buscar `[TODO]`/`[TODO POST-IMPL]` en caps. 3–6 | Agenda 13/06 | 30 min |
| P6 | Actualizar cabecera Cap. 4 (sigue «ESQUELETO»; debería ser BORRADOR) | Detectado 14/06 | 5 min |
| P7 | Crear `admin/reportes/reporte_2026-06-14.md` al cierre | Admin | 15 min |

**Puede esperar a Fase 4 (15–18/06):**

- 16 `[FIG:]` restantes Cap. 5
- Figuras Cap. 6 no insertadas hoy
- `[CITAR:]` inline (21 en EdA; resto mínimo)
- §1.2 Introducción con pregunta de investigación (15/06)
- Transferencia masiva MD → Overleaf (17–18/06)
- Anexos de configuración Cap. 5

---

## BLOQUES DE TRABAJO

### Bloque 0 — 15 min · Alineación

- Leer `admin/STATE.md` (fecha 12/06 — actualizar al cierre)
- Confirmar: sin tareas de laboratorio pendientes
- Listar archivos a adjuntar: `03`, `04`, `05`, `06` (+ opcional `02` EdA como contexto)

---

### Bloque 1 — 1h30 · Cierre Cap. 4 (`cerrar_cap_4_5_figuras`) — PRIORIDAD

**§4.5 Limitaciones (20 min)**

- Eliminar bloque `[TODO]` L345–355; conservar «Texto redactado [IA]» L361–369
- Marcar §4.5 como [HUMANO] tras lectura rápida

**Limpieza skeleton §4.1–4.3 (45 min)**

- Borrar cada `[TODO]` que duplica la prosa [IA] ya redactada debajo (12 ocurrencias)
- Conservar líneas `[FIG:]` — son placeholders válidos para Overleaf
- Actualizar cabecera del capítulo: BORRADOR §4.1–§4.5

**§4.4.1 cierre (15 min)**

- Sustituir `[TODO]` L326 y L333 por prosa breve [HUMANO]: «Las decisiones respondieron a restricciones del laboratorio y al modelo de amenazas, no a elecciones arbitrarias» (adaptar tono)
- Los bullets Wazuh/Suricata, PEP, agente host/contenedor ya están — no reescribir

**Hecho cuando:** Cap. 4 sin `[TODO]` en cuerpo; §4.5 cerrado.

---

### Bloque 2 — 1h · Figuras mínimas Cap. 6

Insertar solo las imprescindibles para que el PDF tutor sea legible:

1. `[FIG: nmap-zerotrust]` — escaneo reducido Escenario B
2. `[FIG: lateral_attempt.log — 400 sin certificado]` — bloqueo mTLS
3. `[FIG: nmap-perimetral]` — contraste visibilidad red plana
4. *(Opcional)* `[FIG: captura tshark lateral.pcap]` — E3 perimetral

Ruta evidencias: sesiones oficiales en `tests/logs/`. No regenerar capturas en laboratorio.

**Hecho cuando:** al menos 3 figuras referenciadas con imagen real o enlace relativo en el MD.

---

### Bloque 3 — 2h · Overleaf + PDF borrador (`setup_overleaf`)

- Crear cuenta/proyecto Overleaf con plantilla ETSINF UPV
- Cargar texto dummy o primer capítulo; **verificar que compila**
- Generar PDF borrador con Caps. 3–6 (pandoc, Overleaf parcial, o export manual — lo que sea más rápido hoy)
- No intentar maquetar los 8 capítulos completos; eso es Fase 4 (17–18/06)

**Hecho cuando:** tienes un PDF descargable con el núcleo de la memoria.

---

### Bloque 4 — 45 min · Email tutor (`envio_tutor_14_06`)

**Contenido del correo (directriz §7):**

1. **Qué entregas:** borrador Caps. 3–6 (~60–70% memoria): análisis del problema, diseño A/B, implantación, pruebas y comparativa KPI.
2. **Qué pides:** revisión del núcleo cuantitativo (§6.4) y coherencia problema→controles→métricas; disponibilidad para cita en despacho si lo ve oportuno.
3. **Qué harás por defecto:** avanzar Caps. 1 y 7 (15–16/06) y PDF completo Overleaf (19/06) con o sin feedback en 48h.

**Acciones:**

- Adjuntar PDF borrador
- Registrar envío en `docs/02_reuniones_tutor/BITACORA_REUNIONES.md`
- Commit de cierre del día si hay cambios en caps. 4–6

**Hecho cuando:** email enviado + bitácora actualizada.

---

### Bloque 5 (opcional, 1h) · Repaso transversal

Solo si los bloques 1–4 terminan antes de las 20:00:

- Buscar `[TODO]` restantes en caps. 3–6
- Verificar referencias cruzadas §3.2.4 ↔ §4.2.3 ↔ §6.1 (4 hitos)
- Esbozo §1.2 en `01_intro.md` con pregunta de investigación (copiar literal de §3.1)

---

## NO HACER HOY

- **No** repetir sesión de laboratorio (KPI y evidencias cerradas 09/06).
- **No** redactar Cap. 7 Conclusiones (agenda 16/06).
- **No** redactar Cap. 1 completo (agenda 15/06; §1.2 solo si sobra tiempo).
- **No** insertar las 16 figuras del Cap. 5 ni todas las del Cap. 6.
- **No** transferencia masiva a Overleaf de todos los capítulos (17–18/06).
- **No** reabrir §6.4 salvo typo crítico que invalide la comparativa.
- **No** bloquear el envío esperando perfección editorial — el hito es **entregar**, no pulir.

---

## CRITERIO DE ÉXITO MÍNIMO DEL DÍA

- Email al tutor **enviado** con PDF borrador Caps. 3–6
- Overleaf creado y **compila** (aunque sea con dummy)
- §4.5 cerrado; Cap. 4 sin `[TODO]` skeleton

**Mínimo absoluto (si el día se acorta):** PDF Caps. 3+6 (problema + pruebas) + email tutor. Cap. 4 y 5 como MD adjunto si no hay tiempo de PDF unificado.

**Stretch (día completo 6–8h):** todo lo anterior + 4 figuras Cap. 6 + §4.4.1 cerrado + repaso coherencia + borrador §1.2.

---

## CIERRE

Al terminar:

1. Actualizar `admin/STATE.md`: hito 14/06 → ✅ o ⚠️ parcial; mover `envio_tutor_14_06` y `setup_overleaf` a DONE si aplican; Fase 4 como DOING.
2. Crear `admin/reportes/reporte_2026-06-14.md`.
3. Commit: «docs: cierre hito 14/06 — Cap. 4 §4.5, figuras mínimas, email tutor» (si procede).
4. **Mañana 15/06 (agenda):** Cap. 1 Introducción §1.1–§1.3 — pregunta de investigación en §1.2 (misma redacción literal que §3.1).
5. Recordatorio: **19/06** — PDF completo Overleaf + email final tutor · **21/06** — entrega plataforma.
