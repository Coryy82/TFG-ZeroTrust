# Sesión 2026-06-11 — Redacción y cierre Cap. 6 §6.4

> **Tipo:** redacción memoria + revisión editorial  
> **Archivo principal:** `docs/03_memoria_tfg/06_pruebas.md`  
> **Fuentes de datos:** `tests/00_PLANTILLA_KPI_v2.md` §3, sesiones `perimetral_sesion_20260523_175204` y `zerotrust_sesion_20260609_130120`

---

## 1. Objetivo de la sesión

Cerrar §6.4 Comparativa A vs B (tabla + prosa §6.4.1–6.4.3), revisar coherencia tras ediciones del autor y alinear terminología de métricas con el protocolo de ataque post-RCE.

---

## 2. Trabajo realizado

### 2.1 Redacción inicial §6.4

- §6.4.1: tabla comparativa desde plantilla KPI §3; marco post-RCE y enlace con pregunta de investigación (ADR 06/06).
- §6.4.2: análisis por dimensión (detección, profundidad, bloqueo, superficie, exfiltración, tráfico); atribución a controles ZT del Cap. 4 §4.3.
- §6.4.3: renombrado a «Matices de la interpretación»; un párrafo sobre asimetría en detección (A sin SIEM por diseño).

### 2.2 Revisión editorial (autor)

- Eliminada frase metodológica confusa en detección («trazabilidad pasiva vs alertado activo»).
- §6.4.3 simplificado: sin repetir limitaciones de §4.5 (Wazuh/SOAR/WSL2); el autor eliminó el último párrafo por redundante.
- Tabla §6.4.1: columnas renombradas a indicadores legibles (G1–G3, E1–E3 entre paréntesis).
- Correcciones tipográficas: Profundidad, Bloqueo.

### 2.3 Terminología G3 — «Bloqueo de comandos desde reverse shell»

**Decisión (autor, 11/06/2026):** sustituir «Bloqueo de hitos» por **«Bloqueo de comandos desde reverse shell»** en la prosa del Cap. 6.

**Motivo:** el atacante opera desde la reverse shell en `webapp`; G3 mide si los comandos post-explotación que persiguen exfiltrar credenciales, acceder al backend o volcar la base de datos quedan frustrados. Más claro que «hitos» (confundible con los cuatro pasos del protocolo §6.1.2).

**Distinción respecto a E2 (volumen exfiltrado):**

| Indicador | Pregunta que responde |
|-----------|------------------------|
| G3 — Bloqueo de comandos desde reverse shell | ¿Los objetivos de ataque lanzados desde la shell tuvieron éxito? (0 % / 100 % bloqueo) |
| E2 — Volumen exfiltrado | ¿Cuántos datos sensibles salieron? (bytes / registros) |

**Aplicado en:** §6.1.3, §6.4.1 (lista + tabla), §6.4.2, §6.4.3. Código **G3** se mantiene en tablas KPI §6.2.2 / §6.3.2.

---

## 3. Estado del Cap. 6 tras la sesión

| Sección | Estado |
|---------|--------|
| §6.1 Metodología | Redactado [HUMANO] |
| §6.2 Escenario A | Redactado [HUMANO] + tablas |
| §6.3 Escenario B | Redactado [HUMANO] + tablas |
| §6.4 Comparativa | Redactado [HUMANO]; revisión autor aplicada |
| Figuras `[FIG:]` | Pendiente |

**Cabecera del capítulo:** actualizada a BORRADOR §6.1–§6.4; plantilla KPI §3 cerrada.

---

## 4. Próximos pasos (agenda)

- Figuras Cap. 6 (`[FIG:]` en §6.2–6.3).
- Cap. 3 Análisis del problema (§3.1–3.4).
- Hito 14/06: email tutor con memoria 60–70 %.
