# Borradores y Pre-trabajos — Estado de cada fichero

> Esta carpeta contiene material generado **antes de la aprobación oficial del TFG** (anterior al 09/04/2026).
> Los ficheros aquí almacenados son referencias históricas, no fuente de verdad para la memoria final.
> Consultar el estado de cada fichero antes de reutilizar cualquier contenido.

---

## Resumen_inicial.md — ✅ VÁLIDO

**Estado:** Aprobado por el tutor Héctor el **09/04/2026**.
**Uso:** Copiar textualmente a `docs/03_memoria_tfg/00_resumen.md`. Ya está hecho (2026-05-24).
Solo retoques cosméticos de redacción en la última pasada de Overleaf (19/06).
**No reescribir desde cero.**
Ver: `docs/02_reuniones_tutor/00_TIMELINE_CORREOS.md §11–§12` para la validación del tutor.

---

## Borrador_Funcional_Inicial.md — ⚠️ SEMILLA HISTÓRICA

**Estado:** Documento pre-propuesta. Estructura de 8 capítulos ETSINF clásica.
**Uso:** Utilizado como semilla para crear el esqueleto de `docs/03_memoria_tfg/` el 2026-05-24.
**No usar directamente** en la memoria: contiene frases genéricas y sin evidencia técnica.
La estructura de capítulos (8 caps ETSINF) sí se adoptó para la memoria final.
**Inconsistencia conocida:** menciona Suricata como sonda de red. En el diseño actual Suricata queda como "trabajo futuro". Ver `docs/03_memoria_tfg/04_diseno.md §4.3.5` para la justificación.

---

## Metricas_iniciales.md — ❌ OBSOLETO — NO USAR

**Estado:** **RECHAZADO** por el tutor Héctor el **11/03/2026** (ver `docs/02_reuniones_tutor/00_TIMELINE_CORREOS.md §10`).
**Por qué está obsoleto:** Las 3 métricas originales (TTD, Profundidad del ataque, Tasa de bloqueo) fueron reformuladas y expandidas a 6 KPIs (G1–G3, E1–E3) con esquema de tupla `(mecanismo_existe: bool, valor)`.
**Fuente de verdad actual:** `tests/00_PLANTILLA_KPI_v2.md` — con los 6 KPIs definidos, medidos para el Escenario A y pendientes para el B.
**Riesgo:** Si este fichero se cuela en la memoria final como métricas oficiales, el tribunal detectará una incoherencia con la propuesta aprobada y los KPIs del capítulo de pruebas.
