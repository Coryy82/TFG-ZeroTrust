# HOY — 2026-06-20 (sábado) · Último buffer antes del depósito

> **Situación:** PDF `Borrador1.2.tex` enviado al tutor el 19/06 ✅. Referencias internas (`\label` / `\cref`) cerradas en borrador principal ✅. Caps. 1–3 y 6–7 pulidos; **caps. 4–5 pendientes de repaso** (prometido al tutor para hoy). Tablas, figuras y `[CITAR:]` siguen abiertos.
> Plan IDs: `repaso_caps_4_5` · `overleaf_figuras` · `overleaf_bibliografia` · `revision_final_entrega`
> Fase: 4 de 4 · **Próximo hito duro: depósito en plataforma el 21/06** (queda **1 día**).

---

## OBJETIVO DEL DÍA

Cerrar repaso de caps. 4–5, insertar tablas KPI y placeholders de figuras/citas suficientes para un PDF depositable mañana.

---

## SI SOLO HACES UNA COSA

Repasa y condensa caps. 4–5 (justificar decisiones, no ampliar Docker) y mete al menos las **tablas KPI del cap. 6** — sin ellas el núcleo cuantitativo queda hueco en el depósito.

---

## CONTEXTO RÁPIDO

| Hecho (19/06) | Pendiente (20–21/06) |
|---|---|
| PDF enviado a Héctor (`Borrador1.2.tex`) | Repaso redaccional caps. 4–5 |
| `\label` / `\cref` en secciones referenciadas | Tablas (`FALTA TABLA`) — prioridad cap. 6 |
| Caps. 1–3 y 6–7 más pulidos | Figuras (`[FIG:]`) — real o placeholder |
| Bitácora y timeline §20 actualizados | Bibliografía (`[CITAR:]`) → `\cite{}` |
| | Depósito plataforma **21/06** |

**Tutor:** sin respuesta a emails del **16/06** y **19/06**. Avanzar sin bloquearse; si llega feedback hoy, incorporar solo lo crítico (≤3h según agenda).

**Directriz caps. 4–5:** leer como *análisis de seguridad*, no manual de despliegue (`00_DIRECTRICES_TUTOR.md` §1–§2). Condensar montaje; destacar *por qué* de cada control.

---

## BLOQUES DE TRABAJO

### Bloque 1 — 2.5h · Repaso caps. 4–5 (`repaso_caps_4_5`)
Prometido al tutor en el correo del 19/06. Fuentes: `04_diseno.md`, `05_desarrollo_implantacion.md` → sincronizar con `Borrador1.2.tex`.

- [ ] Cap. 4 (Diseño): topología A/B, principios ZT, mTLS, Wazuh — narrativa de *decisiones* y enlace a requisitos/métricas (cap. 3)
- [ ] Cap. 5 (Desarrollo): IaC, implementación, problemas de integración — eliminar detalle operativo redundante; mantener solo lo que explica la solución
- [ ] Verificar coherencia de tono con caps. 1–3 y 6–7 ya pulidos
- **Hecho cuando:** caps. 4–5 legibles de un tirón sin sensación de “manual Docker”

---

### Bloque 2 — 2h · Tablas KPI (`overleaf_figuras` / maquetación)
El cap. 6 depende de tablas comparativas; el tutor las mirará en el núcleo cuantitativo.

- [ ] Tabla cronología Escenario A (§6.2.1)
- [ ] Tabla métricas KPI Escenario A (§6.2.2)
- [ ] Tabla métricas KPI Escenario B (§6.3.1)
- [ ] Tabla comparativa final A↔B (§6.4.1)
- [ ] Tablas RF/RNF cap. 3 si aún tienen `FALTA TABLA`
- Fuente de datos: `tests/00_PLANTILLA_KPI_v2.md`, sesión `zerotrust_sesion_20260609_130120`
- **Hecho cuando:** no quedan `FALTA TABLA` en caps. 3 y 6 (o solo en secciones secundarias documentadas)

---

### Bloque 3 — 1.5h · Figuras (`overleaf_figuras`)
Prioridad caps. 4 y 6. Screenshots en `tests/img/` como candidatos.

**Placeholder mínimo viable:**
```latex
\begin{figure}[ht]
  \centering
  \fbox{\parbox{0.7\textwidth}{\centering\vspace{2cm}[FIG: descripción]\vspace{2cm}}}
  \caption{...}
  \label{fig:...}
\end{figure}
```

- [ ] Topologías Escenario A y B (cap. 4)
- [ ] nmap, peticiones, tcpdump, comparativa (cap. 6)
- **Hecho cuando:** no hay `[FIG:]` sueltos en el texto

---

### Bloque 4 — 1.5h · Bibliografía (`overleaf_bibliografia`)
Priorizar citas del cap. 2 (EdA) y cap. 6. No buscar fuentes nuevas — usar `99_bibliografia.md`.

- [ ] Sustituir `[CITAR:]` / `[CITAR FUENTE ...]` por `\cite{clave}`
- [ ] Entradas BibTeX en Overleaf (o bloque `thebibliography`)
- **Hecho cuando:** el PDF no muestra marcadores `[CITAR:` literales en caps. 2 y 6

---

### Bloque 5 — 1h · Feedback tutor + revisión pasada 2 (si da tiempo)
Solo si llega respuesta de Héctor o tras cerrar bloques 1–4.

- [ ] Incorporar correcciones del tutor (máx. 3h si son muchas — acotar a lo bloqueante)
- [ ] Formato ETSINF: portada, márgenes, numeración, índice
- [ ] Compilar PDF candidato final y guardar copia local
- **Hecho cuando:** tienes un PDF listo para depósito mañana con revisión visual hecha

---

## NO HACER HOY

- No reescribir caps. 1–3 ni 6–7 ya enviados al tutor — solo ajustes si feedback explícito
- No ampliar detalle de Docker en caps. 4–5
- No esperar respuesta del tutor para cerrar tablas y placeholders
- No perfeccionar figuras que ya tienen placeholder funcional
- No abrir anexos completos — labels `anexo:*` pueden quedar undefined hasta post-depósito si no bloquean compilación

---

## CIERRE

Al terminar:
1. Actualizar `admin/STATE.md` (marcar `repaso_caps_4_5` y progreso figuras/BibTeX).
2. Copia el bloque `### 2026-06-21` de `admin/AGENDA_SPRINT_DIARIA.md` aquí para mañana.
3. **Mañana 21/06: depósito en plataforma** — hoy es el último día de margen real.
