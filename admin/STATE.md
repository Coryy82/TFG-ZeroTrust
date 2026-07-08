# STATE - Seguimiento TFG Ciberseguridad
Fecha de actualización: 2026-07-08

## 0. Fase actual del proyecto

> **Convocatoria:** julio 2026.
> **Memoria:** cerrada y depositada. Fuente canónica: `docs/03_memoria_tfg/Borradores y pretrabajos/Overleaf/DocumentoFinalOverleaf.tex`.
> **Fase activa:** preparación de la **defensa oral** (20 min).
> **Plan de sprint de entrega (21/06):** completado — ver `admin/ROADMAP_v2_sprint_final.md` (archivado como referencia histórica).
> **Blueprint de presentación:** `docs/03_memoria_tfg/00_PAUTAS_IMPORTANTES_MEMORIA/Esqueleto-Presentacion-TFG.md`.

> **Referencia estructural de la memoria:** `docs/03_memoria_tfg/00_PAUTAS_IMPORTANTES_MEMORIA/EstucturayContenidodeunTFG.md`.
> **Política editorial:** `docs/03_memoria_tfg/00_PAUTAS_IMPORTANTES_MEMORIA/Recomendaciones-Escritura-TFG.md` + `perfil_escritura_autor.md`.

## 1. Resumen de estado

| Área | Estado |
|------|--------|
| Laboratorio (Escenarios A y B) | ✅ Estable — sin cambios desde sesión oficial `zerotrust_sesion_20260609_130120` |
| Comparativa KPI A↔B | ✅ Cerrada (09/06) |
| Memoria LaTeX (`DocumentoFinalOverleaf.tex`) | ✅ Caps. 1–7 + anexos + glosario |
| Figuras (`Overleaf/img/`) | ✅ Integradas (32 JPG; inventario en `img/README.md`) |
| Tablas KPI / comparativa | ✅ En cap. 3 y cap. 6 |
| Bibliografía | ✅ Citas en cuerpo + entradas BibTeX |
| Anexos (protocolo, configs, scripts, código) | ✅ Completados |
| Feedback tutor post-entrega (CWE, figuras, formato) | ✅ Incorporado |
| Auditoría final de memoria | ✅ Realizada — lista para defender |
| Defensa oral (diapositivas + ensayo) | 🔄 En curso |
| Tutor | 🟢 Luz verde para convocatoria julio (feedback formato/CWE; sin bloqueos) |

## 2. Hitos completados (Sprint Final → cierre memoria)

| Fecha | Hito | Estado |
|-------|------|--------|
| 06/06 | Índice anotado enviado al tutor | ✅ |
| 09/06 | Escenario B + KPIs §2/§3 cerrados (sesión `130120`) | ✅ |
| 16/06 | Borrador caps. 2–6 al tutor | ✅ |
| 19/06 | PDF `Borrador1.2.tex` al tutor | ✅ |
| 20–21/06 | Repaso caps. 4–5, tablas, figuras, depósito plataforma | ✅ |
| Post-21/06 | `DocumentoFinalOverleaf.tex`: figuras, anexos, glosario, BibTeX | ✅ |
| Post-21/06 | PDF versión final al tutor + solicitud defensa julio | ✅ |
| Post-21/06 | Feedback tutor (CWE, contextualización figuras, formato) | ✅ Incorporado |
| Post-21/06 | Auditoría final (coherencia, defensa, rigor académico) | ✅ |

## 3. Pendientes menores (no bloquean defensa)

| ID | Descripción | Prioridad |
|----|-------------|-----------|
| P1 | Palabras clave valencianas vacías en `\keywords{}` (L83) | Baja — portada |
| P2 | Comentarios `%[REVISADO:...]` en `.tex` (L1256–1271) | Baja — solo si se entrega fuente |
| P3 | `\label` antes de `\caption` en tablas no referenciadas (caps. 3, 6) | Baja — higiene LaTeX |
| P4 | Referencia `\cref{sec:4.2.3}` en §3.2.4 (podría apuntar a §3.2.4) | Baja |

## 4. Tablero actual — Fase Defensa

### TODO
- [ ] **[HUMANO] `presentacion_diapositivas`** — Maquetar slides según `Esqueleto-Presentacion-TFG.md` (16 slides + backup).
- [ ] **[HUMANO] `demo_video_ab`** — Vídeo comparativo Escenario A vs B (slide 11, ~2:30 min).
- [ ] **[HUMANO] `ensayo_cronometrado`** — Ensayo oral ≤ 20 min con cronómetro; preparar respuestas a Q1–Q4 (ver §6).
- [ ] **[HUMANO] `slides_backup_qa`** — Slides de backup: compose, nginx.conf, OpenSSL, detalle KPIs.
- [ ] **[HUMANO] `p1_keywords_val`** — Rellenar `\keywords{}` valenciano (2 min, opcional pre-defensa).

### DOING
- [ ] **[HUMANO] `presentacion_diapositivas`** — Esqueleto de 16 slides + reparto temporal definido en `Esqueleto-Presentacion-TFG.md`.

### DONE (post-sprint)
- [x] **`memoria_final_overleaf`** — `DocumentoFinalOverleaf.tex` completo: caps. 1–7, figuras, tablas, anexos, glosario, bibliografía. (2026-06/post-21)
- [x] **`figuras_integradas`** — Marcadores `[FIG:]` sustituidos; `\FloatBarrier`; captions sin "Fuente: elaboración propia". (2026-06)
- [x] **`anexos_completos`** — Protocolo, configs, scripts captura, código app, reglas Wazuh. (2026-06)
- [x] **`feedback_tutor_cwe_figuras`** — CWE corregidos (308, 522, 200); lectura de figuras; intro CWE §5.2.3. (2026-06/post-21)
- [x] **`auditoria_final_memoria`** — Veredicto: lista para entregar y defender (confianza medio-alta). (2026-06/post-21)
- [x] **`correcciones_auditoria`** — `\label` tabla Wazuh; "cinco patrones" §4.3.4; eliminada salvedad "parcial" observabilidad. (2026-07)
- [x] **`envio_tutor_final`** — PDF final al tutor; luz verde convocatoria julio. (2026-06/post-21)

*(Hitos técnicos y de redacción del sprint: ver sección DONE histórica en commits y `ROADMAP_v2_sprint_final.md`.)*

## 5. Riesgos activos (fase defensa)

| Nivel | Riesgo | Mitigación |
|-------|--------|------------|
| MEDIO | Ensayo oral no cronometrado → exceder 20 min | Ensayo con cronómetro; slides backup fuera del tiempo |
| MEDIO | Pregunta tribunal sobre muestra n=1 | Respuesta preparada: §7.2 limitaciones; cifras ilustrativas |
| MEDIO | Pregunta sobre valor de Wazuh vs contención | Separar contención (segmentación/mTLS) de detección (G1) |
| BAJO | Demo en vivo falla | Vídeo pregrabado como plan B (slide 11) |
| BAJO | Detalle implementación en exposición | Regla: conceptual en slides; detalle en backup Q&A |

## 6. Preguntas probables del tribunal (preparar respuesta)

1. **Muestra única:** ¿Por qué una sesión por escenario? → Limitación reconocida §7.2; reproducible con scripts de captura.
2. **Valor de Wazuh:** ¿Qué aporta si la contención ya la dan segmentación y mTLS? → Detección activa (G1); visibilidad para respuesta; no sustituye controles de red.
3. **CWE en cadena pre-RCE:** ¿Por qué esos CWE? → Clasificación de debilidades del baseline A; fuera de ventana de medición post-RCE.
4. **Generalización:** ¿Extrapolable a Kubernetes/producción? → Laboratorio Docker; líneas futuro §7.3; resultados representativos del contraste, no estadísticos.

## 7. Artefactos clave

| Artefacto | Ruta |
|-----------|------|
| Memoria final | `docs/03_memoria_tfg/Borradores y pretrabajos/Overleaf/DocumentoFinalOverleaf.tex` |
| Figuras | `docs/03_memoria_tfg/Borradores y pretrabajos/Overleaf/img/` |
| Anexos LaTeX | `docs/03_memoria_tfg/Borradores y pretrabajos/Overleaf/anexos/` |
| Esqueleto presentación | `docs/03_memoria_tfg/00_PAUTAS_IMPORTANTES_MEMORIA/Esqueleto-Presentacion-TFG.md` |
| Evidencias sesión B | `tests/logs/zerotrust_sesion_20260609_130120/` |
| KPI plantilla | `tests/00_PLANTILLA_KPI_v2.md` |
| Infra Escenario A | `infra/perimetral/` |
| Infra Escenario B | `infra/zero_trust/` |

## 8. Comunicación con tutor

- **Último feedback relevante:** formato (páginas cargadas de imágenes), contextualización de figuras, uso correcto de CWE. Luz verde para julio.
- **Estado:** sin bloqueos pendientes para la defensa.
- **Bitácora:** `docs/02_reuniones_tutor/BITACORA_REUNIONES.md` (entradas 2026-06-19 en adelante).
- **Timeline:** `docs/02_reuniones_tutor/00_TIMELINE_CORREOS.md` (§20–§22).
