# HOY — 2026-07-08 (martes) · Preparación defensa oral

> **Situación:** Memoria cerrada y depositada ✅. `DocumentoFinalOverleaf.tex` es la fuente canónica. Feedback del tutor (CWE, figuras, formato) incorporado ✅. Luz verde para convocatoria julio ✅.
> **Fase activa:** defensa oral (20 min).
> Plan IDs: `presentacion_diapositivas` · `demo_video_ab` · `ensayo_cronometrado` · `slides_backup_qa`
> Blueprint: `docs/03_memoria_tfg/00_PAUTAS_IMPORTANTES_MEMORIA/Esqueleto-Presentacion-TFG.md`

---

## OBJETIVO DEL DÍA

Avanzar en la maquetación de las diapositivas principales (slides 1–8: apertura → metodología) siguiendo el esqueleto de presentación.

---

## SI SOLO HACES UNA COSA

Maquetar **slides 1–3** (portada, índice, motivación) con el reparto temporal del esqueleto. Sin ellas no hay hilo narrativo para el resto.

---

## CONTEXTO RÁPIDO

| Hecho (cerrado) | Pendiente (defensa) |
|---|---|
| Memoria completa en Overleaf | Diapositivas 1–16 (+ backup Q&A) |
| 32 figuras integradas | Vídeo demo A vs B (~2:30 min, slide 11) |
| Anexos, glosario, bibliografía | Ensayo cronometrado ≤ 20 min |
| KPI A↔B documentados (sesión `130120`) | Respuestas preparadas a Q1–Q4 (ver `STATE.md` §6) |
| Feedback tutor incorporado | Slides backup (compose, mTLS, KPIs) |
| Auditoría final: lista para defender | Palabras clave valencianas (P1, opcional) |

**Directriz del tutor (trasladada a slides):** leer diseño/desarrollo como *análisis de seguridad*, no manual Docker. Slides conceptuales (`cap04-*`, `cap06-*`); detalle implementación en backup.

---

## BLOQUES DE TRABAJO

### Bloque 1 — 2h · Slides 1–4 (Apertura + Problema)
Fuente: `Esqueleto-Presentacion-TFG.md` slides 1–4.

- [ ] Slide 1: portada (título, autor, tutor, ETSINF, fecha defensa)
- [ ] Slide 2: índice / hoja de ruta (mini-índice lateral en slides siguientes)
- [ ] Slide 3: motivación (microservicios, red plana, post-explotación)
- [ ] Slide 4: modelo perimetral — el punto ciego (`cap04-topologia-perimetral.jpg`)
- **Hecho cuando:** slides 1–4 maquetadas con notas del orador del esqueleto

---

### Bloque 2 — 2h · Slides 5–8 (Fundamentos + Tesis + Metodología)
- [ ] Slide 5: Zero Trust — never trust, always verify
- [ ] Slide 6: hueco + pregunta + hipótesis (tcolorbox de la memoria)
- [ ] Slide 7: propuesta + diseño experimental (dos escenarios idénticos)
- [ ] Slide 8: metodología KPI (tabla G1–G3, E1–E3 simplificada)
- **Hecho cuando:** el tribunal entiende *qué* se mide y *por qué* antes de ver los escenarios

---

### Bloque 3 — 1.5h · Slides 9–10 (Escenarios A y B)
- [ ] Slide 9: Escenario A — topología + cadena pre-RCE (conceptual)
- [ ] Slide 10: Escenario B — 3 zonas + mTLS + Wazuh (`cap04-topologia-zerotrust.jpg`, `cap04-mtls-handshake.jpg`)
- **Hecho cuando:** contraste visual claro entre A (2 redes, HTTP) y B (3 zonas, mTLS)

---

### Bloque 4 — 1h · Ensayo parcial + cronómetro
- [ ] Leer en voz alta slides 1–10 con notas del orador
- [ ] Cronometrar: objetivo ≤ 10 min para este bloque
- [ ] Anotar slides que se alargan → condensar texto visual
- **Hecho cuando:** tienes tiempo medido y ajustes identificados

---

## NO HACER HOY

- No reabrir la memoria salvo P1 (keywords valencianas, 2 min)
- No retocar infra/laboratorio — está congelado para defensa
- No perfeccionar slides 11–16 hasta tener 1–10 estables
- No grabar el vídeo demo hasta tener storyboard de slide 11

---

## CIERRE

Al terminar:
1. Actualizar `admin/STATE.md` (marcar progreso en `presentacion_diapositivas`).
2. Preparar bloque de mañana: slides 11–13 (demo + resultados KPI + atribución).
