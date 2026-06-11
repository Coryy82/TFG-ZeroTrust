# HOY — 2026-06-11 (jueves) · §6.4 COMPARATIVA + CIERRE CAP. 6

> **Situación:** Fase 3 — Semana 3. **Hito 09/06 ✅** · **Hito 10/06 parcial ✅** — Caps. 4 §4.1–4.3, Cap. 6 §6.1–6.3, EdA §2.7 cerrados.
> **Deuda del 10/06:** §6.4 comparativa A vs B no se cerró (agenda lo priorizaba; se pospuso tras Bloques 1–3).
> **Bloqueo activo:** memoria incompleta para hito 14/06 — faltan §6.4, Cap. 3, Cap. 5, §4.5.
> Plan IDs: `redactar_cap_3_4_5` (prioridad) → `preparar_reunion_tutor` (opcional)
> Fase: 3 de 4 · Semana 3 · **Próximo hito duro 14/06:** Caps. 3–6 en borrador + email tutor 60–70%. **Quedan 3 días.**

---

## OBJETIVO DEL DÍA

1. **Cerrar el corazón cuantitativo del TFG:** redactar `06_pruebas.md` §6.4 completo (tabla §3 plantilla KPI → prosa + análisis por métrica + limitaciones honestas).
2. **Recuperar agenda 11/06:** figuras Cap. 6 y primera pasada de cierre del capítulo.
3. **Arrancar Cap. 3** si §6.4 queda cerrado antes del mediodía.

---

## SI SOLO HACES UNA COSA

Redacta **§6.4.2 Análisis cuantitativo** en `docs/03_memoria_tfg/06_pruebas.md`: un párrafo por métrica (G1–G3, E1–E3) enlazando valor A vs B con el mecanismo Zero Trust que lo explica. Fuente única: `tests/00_PLANTILLA_KPI_v2.md` §3 (ya rellena). Sin §6.4 no hay tesis defendible ni coherencia con Cap. 4 y 7.

---

## CONTEXTO: QUÉ CAMBIÓ DESDE EL 10/06

| Tema | Estado 10/06 (cierre) | Estado actual (inicio 11/06) |
|------|------------------------|------------------------------|
| Cap. 6 §6.1–6.3 | ✅ Redactados [HUMANO] | Listos — no reabrir salvo coherencia §6.4 |
| Cap. 4 §4.1–4.3 | ✅ Redactados | §4.4 tabla OK; §4.5 texto [IA] con `[TODO]` residual |
| EdA §2.7 | ✅ Cerrado | Cap. 2 completo para borrador |
| §6.4 comparativa | ❌ Pendiente (deuda) | **Prioridad absoluta hoy** |
| Cap. 3 / Cap. 5 | Sin empezar | Agenda 11–12/06 |
| Hito 14/06 | 4 días | **3 días** — en riesgo |

**Fuentes de verdad para §6.4 (no inventar):**

- `tests/00_PLANTILLA_KPI_v2.md` §3 (cuadro comparativo final — celdas ya rellenas)
- `tests/00_PLANTILLA_KPI_v2.md` §1 (A) + §2 (B) para evidencias y rutas
- `docs/04_diario_laboratorio/20260609_Sesion_PruebasAB_Wazuh_Deteccion.md` §12
- ADR 2026-06-06: pregunta de investigación, no solo «comparar arquitecturas»

**Valores §3 a trasladar a la tabla §6.4.1:**

| Cód. | A (perimetral) | B (Zero Trust) | Δ |
|------|----------------|----------------|---|
| G1 | `(false, ∞)` | `(true, 22 s)` | Detección inexistente → Wazuh 100100 |
| G2 | 3 nodos | 1 nodo | −67 % alcance lateral |
| G3 | `(false, 0 %)` | `(true, 100 %)` | Contención inexistente → bloqueo total hitos |
| E1 | 3/3 servicios | 1/3 | −67 % superficie visible |
| E2 | ~766 B / 3 reg. + 1 cred. | 0 B / 0 reg. | Exfil anulada |
| E3 | texto claro (HTTP) | cifrado + rechazado | mTLS + PEP |

---

## BLOQUES DE TRABAJO

### Bloque 0 — 15 min · Alineación

- Leer `admin/STATE.md` y confirmar: sin tareas de laboratorio pendientes
- Abrir `06_pruebas.md` §6.4 y `tests/00_PLANTILLA_KPI_v2.md` §3 en paralelo
- (Opcional) Crear `admin/reportes/reporte_2026-06-11.md` al cierre del día

---

### Bloque 1 — 5h · Cap. 6 §6.4 Comparativa A vs B (`redactar_cap_3_4_5`) — PRIORIDAD MÁXIMA

Recupera la agenda **vencida del 10/06**. No abrir Cap. 3 hasta tener §6.4.1–6.4.3 en prosa.

**§6.4.1 Tabla comparativa final (1h)**

- Completar tabla en `06_pruebas.md` con valores reales de plantilla §3 (sustituir `[TODO]` en columnas B y Mejora)
- Párrafo introductorio: qué compara la tabla (fase post-RCE, mismo T0, mismo protocolo)
- Enlazar pregunta de investigación (ADR 06/06): la tabla responde «en qué medida», no solo «si son distintos»

**§6.4.2 Análisis cuantitativo (3h)** — **corazón del día**

- Un párrafo por métrica G1–G3, E1–E3 en estilo [HUMANO]
- G1: ausencia de SIEM en A vs Wazuh 22 s en B; matizar limitación (sin 100101/100104; poll 2 s)
- G2/G3: movimiento lateral contenido — microsegmentación, mTLS, Flask `127.0.0.1`
- E1–E3: superficie, exfil, tráfico — atribuir mecanismo concreto del Escenario B (Cap. 4 §4.3)
- Sin códigos G/E en prosa narrativa; usar nombres descriptivos («tiempo de detección», «profundidad del ataque»)

**§6.4.3 Casos sin mejora o degradación (1h)**

- G1: 22 s no es detección instantánea; `curl` efímero no alertó (100101)
- Honestidad: qué no midió Wazuh y por qué no invalida la contención (G2/G3/E1–E3 sí mejoraron)
- Limitación laboratorio: Docker Desktop/WSL2, sin auditd completo (ADR 2026-06-04)

**Hecho cuando:** §6.4 sin `[TODO POST-PRUEBAS]`; tabla §6.4.1 completa; §6.4.2 con 6 párrafos mínimo.

---

### Bloque 2 — 2h · Figuras y cierre Cap. 6 (agenda 11/06)

Solo si Bloque 1 avanza bien.

- Resolver `[FIG:]` pendientes en §6.2–6.3: capturas reales o Mermaid (topología, nmap ZT, lateral 400)
- Primera pasada de coherencia Cap. 6 completo: §6.1 metodología ↔ §6.4 conclusiones cuantitativas
- Verificar que §6.4 no contradice §6.2 (A) ni §6.3 (B)

**Hecho cuando:** Cap. 6 legible de extremo a extremo sin saltos lógicos.

---

### Bloque 3 — 3h · Cap. 3 Análisis del Problema (agenda 11/06)

Solo si §6.4 cerrado antes de las 14:00; si no, dejar para mañana 12/06.

**Insumos:** `docs/02_reuniones_tutor/00_DIRECTRICES_TUTOR.md` §3, modelo amenazas ya en `03_analisis_problema.md` §3.2

- §3.1 Descripción del problema — formalizar red plana post-RCE (2 párrafos [HUMANO])
- §3.2 Modelo de amenazas — expandir skeleton existente a prosa (atacante, activos, alcance)
- §3.3 Requisitos — traducir amenazas en criterios verificables para diseño y pruebas
- §3.4 KPIs — explicar G1–G3 y E1–E3 en prosa (sin repetir §6.4; aquí es *definición*, allí *resultados*)

**Hecho cuando:** Cap. 3 sin `[TODO]` en §3.1–3.4.

---

### Bloque 4 (opcional, 1h) · Cierre Cap. 4 + dossier tutor

- §4.5 Limitaciones: fusionar texto [IA] existente, quitar `[TODO]` del esqueleto
- Actualizar `01_intro.md` §1.2 con pregunta de investigación (ADR 06/06) — prepara hito 14/06
- Borrador dossier 1–2 páginas para cita tutor: pregunta + extracto §6.4 + tabla §3

---

## NO HACER HOY

- **No** repetir sesión de laboratorio (KPI cerrado; evidencias en `130120` y `175204`).
- **No** abrir Overleaf (hito 14/06).
- **No** redactar Cap. 7 Conclusiones antes de §6.4 cerrado.
- **No** reabrir §6.1–6.3 salvo corrección menor de coherencia con §6.4.
- **No** perfeccionar infra salvo regresión bloqueante (>2h → documentar y seguir redactando).

---

## CRITERIO DE ÉXITO MÍNIMO DEL DÍA

- `06_pruebas.md` §6.4.1 tabla completa + §6.4.2 análisis por métrica redactado
- §6.4.3 limitaciones honestas (G1 parcial, cobertura Wazuh)

**Mínimo absoluto (si el día se acorta):** solo §6.4.2 (6 párrafos) + tabla §6.4.1 rellena.

**Stretch (día completo 8h+):** Cap. 6 figuras + Cap. 3 §3.1–3.2 + §4.5.

---

## CIERRE

Al terminar:

1. Actualizar `admin/STATE.md`: marcar §6.4 si cerrado; avance Cap. 3 si aplica.
2. Si cerraste §6.4: anotar en diario laboratorio párrafo «redacción §6.4 completada».
3. **Mañana 12/06 (agenda):** Cap. 5 Desarrollo e Implantación §5.1–5.4.
4. Recordatorio: **14/06 en 3 días** — email tutor con memoria 60–70% + `setup_overleaf`.
