# ROADMAP v2 — Sprint Final 21/06/2026

> **Versión:** 2.0 — Sprint de entrega en convocatoria de julio
> **Creado:** 2026-05-24
> **Deadline fijo:** 21/06/2026
> **Sustituye a:** `ROADMAP_v1_archivado.md` (plan original orientado a septiembre)
> **ADR asociado:** ver `admin/DECISIONS_LOG.md` — entrada 2026-05-24

---

## DISPONIBILIDAD REAL

| Periodo              | Disponibilidad | Horas efectivas estimadas |
|----------------------|----------------|--------------------------|
| 24/05 → 01/06        | 1-2h/día       | ~9-12h                   |
| 02/06 → 21/06        | ~12h/día × 0.75| ~180h                    |
| **TOTAL**            |                | **~190-200h**            |

---

## ESTRATEGIA GENERAL

El cambio de convocatoria (septiembre → julio) invierte la jerarquía de trabajo:
**redacción > evidencia > implementación nueva**.

La parte técnica que no esté lista antes del 09/06 no entra en la memoria.
La regla de timeboxing del ROADMAP v1 (2h máximo por problema) se mantiene y se refuerza:
cualquier componente técnico que supere su presupuesto en >30% activa su fallback documentado.

---

## FASE 1 — SEMANA 1 (24/05–31/05) · Capacidad ~9-12h

**Objetivo único:** borrador "razonablemente decente" para el tutor antes del 02/06.

| Día        | Tarea principal                                                                 | Tiempo |
|------------|---------------------------------------------------------------------------------|--------|
| 24/05 dom  | Esqueleto 9 caps ETSINF en `docs/03_memoria_tfg/`. Archivar ROADMAP v1. ADR.   | 2h     |
| 25-27/05   | Estado del Arte v0: NIST 800-207, BeyondCorp, OWASP, microsegmentación (~5 pp) | 4-5h   |
| 28-29/05   | Esqueleto Cap. 4 Diseño + Cap. 5 Desarrollo. Justificación Wazuh vs Suricata.  | 3h     |
| 30-31/05   | Revisión borrador. **Envío al tutor el domingo 31/05 por la tarde.**            | 2-3h   |

**Hito de fase:** correo al tutor con (1) índice 8 caps, (2) Estado del Arte v0, (3) propuesta alcance Escenario B.

---

## FASE 2 — SEMANA 2 (02/06–07/06) · Capacidad ~80h

**Objetivo único:** Escenario B funcional con segmentación + identidad + mTLS + observabilidad.

| Día        | Tarea principal                                                                      | Tiempo |
|------------|--------------------------------------------------------------------------------------|--------|
| 01/06 lun  | Especificación detallada Escenario B. Reglas G1/G3 definidas.                        | 2h     |
| 02-03/06   | Implementar `infra/zero_trust/`: docker-compose 3 redes, mTLS OpenSSL, Caddy/Nginx. | 24h    |
| 04/06 jue  | Wazuh manager + agent en webapp. **Checkpoint 20:00: si falla → switch a Falco.**   | 12h    |
| 05/06 vie  | Reglas custom para 4 hitos post-RCE. Documentar cada regla.                         | 12h    |
| 06-07/06   | Pruebas A/B post-RCE. Logs en `tests/logs/zerotrust_sesion_*/`. Verificar 4 hitos.  | 24h    |

**Criterio de fallback Wazuh → Falco:** si a las 8h netas de trabajo el 04/06 no hay agent enrollado y ≥1 alerta activa, se abandona Wazuh y se despliega Falco. Decisión documentada en DECISIONS_LOG.md. La tesis sigue siendo defendible con cualquiera de los dos.

**Hito de fase:** `infra/zero_trust/` levanta, los 4 hitos post-RCE están detectados o bloqueados, logs capturados.

---

## FASE 3 — SEMANA 3 (08/06–14/06) · Capacidad ~80h

**Objetivo único:** comparativa KPI cerrada + 60% de la memoria redactada.

| Día        | Tarea principal                                                                       | Tiempo |
|------------|---------------------------------------------------------------------------------------|--------|
| 08/06 lun  | Cerrar plantilla KPI v2 §2 (Escenario B) y §3 (comparativa A vs B).                 | 12h    |
| 09/06 mar  | Cap. 4 Diseño completo (subsección A desde diarios, subsección B desde spec/commits). | 12h    |
| 10-11/06   | Cap. 6 Pruebas y Resultados. Tablas KPI, capturas, comparativa cuantitativa.          | 24h    |
| 12-13/06   | Cap. 3 Análisis del Problema + Cap. 5 Desarrollo e Implantación.                     | 24h    |
| 14/06 dom  | Checkpoint. Setup Overleaf (plantilla ETSINF, compilación con dummy). Email al tutor. | 8h    |

**Hito de fase:** Capítulos 3, 4, 5, 6 en borrador. Overleaf compila. Email al tutor con memoria al 60-70%.

---

## FASE 4 — SEMANA 4 (15/06–21/06) · Capacidad ~70h

**Objetivo único:** memoria compilada, revisada y entregada.

| Día        | Tarea principal                                                                          | Tiempo |
|------------|------------------------------------------------------------------------------------------|--------|
| 15/06 lun  | Cap. 1 Introducción + objetivos + estructura.                                            | 12h    |
| 16/06 mar  | Cap. 7 Conclusiones + Trabajo Futuro.                                                    | 12h    |
| 17/06 mié  | Transferir EdA + Caps 3, 4 a Overleaf. BibTeX.                                          | 12h    |
| 18/06 jue  | Transferir resto. Maquetar figuras, tablas, código. Resolver errores LaTeX.              | 12h    |
| 19/06 vie  | Revisión completa (ortografía, coherencia, citas). **Email al tutor con PDF final.**     | 12h    |
| 20/06 sáb  | Incorporar correcciones. Revisión pasada 2. Formato ETSINF.                              | 10h    |
| 21/06 dom  | Revisión pasada 3. PDF definitivo. **Depósito en plataforma.** Buffer de 4-5h.          | 6h     |

**Hito de fase:** TFG depositado en plataforma antes del cierre del 21/06.

---

## ALCANCE TÉCNICO REDUCIDO DEL ESCENARIO B

**Se implementa:**
- Microsegmentación con 3 redes Docker aisladas (`web_zone`, `db_zone`, `mgmt_zone`)
- Identidad de servicio mínima (sin credenciales compartidas entre contenedores, `.env` por servicio)
- mTLS entre `webapp` ↔ `backend` (certs autofirmados OpenSSL, un único canal)
- Wazuh manager + 1 agent en `webapp`, con 3-5 reglas custom para los 4 hitos post-RCE
- Plan B documentado: Falco como sustituto si Wazuh bloquea >8h netas

**NO se implementa (documentar como Trabajo Futuro):**
- Dashboard Wazuh custom ni integraciones externas
- mTLS en todo el stack (solo webapp ↔ backend)
- Automatización avanzada de ataques con scripts Bash/Python
- Ataques de spoofing adicionales al set original
- Escalado a múltiples agentes Wazuh
- Despliegue real en Kubernetes / cloud
- Suricata como sonda de red adicional (se justifica la elección Wazuh vs Suricata en Cap. 4)

---

## ESTRUCTURA DE MEMORIA (ETSINF 8 CAPS)

```
00_resumen.md              → Abstract (aprobado por tutor 09/04/2026, copiar de Resumen_inicial.md)
01_intro.md                → Motivación, objetivos, estructura
02_estado_arte.md          → Evolución contenedores, ZT, NIST 800-207, BeyondCorp, OWASP
03_analisis_problema.md    → Modelo de amenazas v2 (validado), requisitos F/NF
04_diseno.md               → Arquitecturas A y B, tecnología elegida, justificación Wazuh vs Suricata
05_desarrollo_implantacion.md → Infrastructure as Code, decisiones de implementación, referencia a diarios
06_pruebas.md              → Tablas KPI v2 §3, capturas, comparativa A vs B (CORAZÓN DEL TFG)
07_conclusiones.md         → Resultados, limitaciones, trabajo futuro
99_bibliografia.md         → BibTeX / referencias (gestionar con marcadores [CITAR:] inline)
```

---

## CAMINO CRÍTICO Y NODOS DE RIESGO

```
Esqueleto+EdA(S1) → Envío tutor(31/05) → Spec+Impl ZT(S2) → [CHECKPOINT WAZUH 04/06]
→ Pruebas A/B(S2) → KPIs §2§3(S3) → Caps 4+6(S3) → Caps 3+5(S3)
→ [CHECKPOINT OVERLEAF 14/06] → Caps 1+7(S4) → Overleaf completo(S4)
→ Envío PDF tutor(19/06) → Depósito(21/06)
```

**Nodo con mayor varianza:** Wazuh (D12 del sprint). Fallback documentado y con timestamp duro.
**Regla de cierre de capítulos:** ningún capítulo se reabre una vez cerrado en borrador. Los ajustes van en segunda pasada de revisión.

---

## COMUNICACIÓN CON EL TUTOR

| Fecha     | Qué se envía                                                  | Qué se pide                                   |
|-----------|---------------------------------------------------------------|-----------------------------------------------|
| 31/05     | Índice 8 caps + Estado del Arte v0 + propuesta alcance B      | Validación "razonablemente decente"            |
| 14/06     | Memoria 60-70% (caps 3, 4, 5, 6 en borrador)                 | Revisión del corazón cuantitativo             |
| 19/06     | PDF compilado completo                                        | Correcciones de última pasada (48h plazo)     |

**Regla de no-bloqueo:** si el tutor no responde en 48h, se avanza igualmente. Su feedback se incorpora como ajuste, no como rediseño.

---

## CONDICIONES MÍNIMAS PARA LLEGAR AL 21/06

1. Borrador enviado al tutor antes del 02/06 (con o sin respuesta positiva).
2. Wazuh o Falco con ≥3 alertas distintas antes del 09/06.
3. Plantilla KPI v2 §2 y §3 con valores reales antes del 10/06.
4. Caps. 4 y 6 en borrador antes del 14/06.
5. PDF compilado en Overleaf antes del 19/06.
6. Sin imprevisto grave en el periodo 02-21/06.
7. Timeboxing respetado: >30% de sobrecoste en cualquier componente técnico activa fallback inmediato.

---

## PROBABILIDAD ESTIMADA DE ÉXITO

| Escenario                                      | Probabilidad |
|------------------------------------------------|--------------|
| Todas las condiciones se cumplen               | 67-72%       |
| Se activa Plan B (Falco en lugar de Wazuh)     | 55-60%       |
| Tutor no responde hasta el 10/06               | 45-55%       |
| Pérdida de 2+ días por imprevisto              | 30-40%       |

**Plan C activo hasta el 12/06:** si el Escenario B no está funcional ese día, reasignar a convocatoria de septiembre antes de quemar las 50h finales.
