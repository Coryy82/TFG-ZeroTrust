# HOY — 2026-06-19 (viernes) · ⚠️ HITO DURO: PDF AL TUTOR HOY

> **Situación:** Caps. 1–7 transferidos a Overleaf ✅. Quedan 3 tareas de maquetación antes de compilar el PDF final.
> Plan IDs: `overleaf_figuras` · `overleaf_bibliografia` · `overleaf_referencias_internas` · `envio_tutor_19_06`
> Fase: 4 de 4 · **Próximo hito duro: depósito en plataforma el 21/06.**

---

## OBJETIVO DEL DÍA

PDF compilado en Overleaf enviado al tutor antes de las 20:00.

---

## SI SOLO HACES UNA COSA

Compila el PDF aunque falten figuras y citas — usa placeholders — y envíaselo al tutor. Un PDF imperfecto hoy vale más que uno perfecto el lunes.

---

## BLOQUES DE TRABAJO

### Bloque 1 — 1.5h · Referencias internas `\label` / `\cref`
Añadir `\label` justo después de cada `\section` y `\subsection`, luego reemplazar las menciones textuales del tipo "como se ve en la sección 2.1" por `\cref{}`.

**Patrón para labels:**
```latex
\section{El modelo de seguridad perimetral y sus limitaciones}
\label{sec:perimetral}
```

**Patrón para referencias:**
```latex
% En lugar de "como se explica en la sección 2.1"
como se explica en la \cref{sec:perimetral}
```

**Paquete necesario** (añadir en el preámbulo si no está):
```latex
\usepackage[spanish]{cleveref}
```

- [ ] Añadir `\label{sec:X}` a todos los `\section` y `\subsection` de caps. 1–7
- [ ] Buscar referencias textuales a secciones y sustituir por `\cref{}`
- **Hecho cuando:** el PDF compila sin `undefined label` warnings en las referencias que ya hayas puesto

---

### Bloque 2 — 2h · Bibliografía `\cite{}`
Convertir los marcadores `[CITAR: ...]` que queden en el texto a `\cite{clave}` y añadir la entrada BibTeX correspondiente.

**Flujo mínimo viable:**
```latex
% En el texto
según el marco de referencia de NIST~\cite{nist800207}

% En el fichero .bib (o bloque \begin{thebibliography})
@techreport{nist800207,
  author  = {Rose, Scott and others},
  title   = {{Zero Trust Architecture}},
  institution = {NIST},
  year    = {2020},
  number  = {SP 800-207},
  url     = {https://doi.org/10.6028/NIST.SP.800-207}
}
```

- [ ] Localizar todos los `[CITAR:]` restantes en el `.tex`
- [ ] Para cada uno: añadir `\cite{clave}` en el texto y la entrada en el `.bib`
- [ ] Priorizar las citas del Cap. 2 (EdA) y Cap. 6 (Pruebas) — son las que el tutor leerá primero
- **Hecho cuando:** no quedan `[CITAR:]` literales en el PDF compilado

---

### Bloque 3 — 1.5h · Figuras
Para cada marcador `[FIG: descripción]` tienes dos opciones:

**Opción A — figura real** (si ya tienes la imagen):
```latex
\begin{figure}[ht]
  \centering
  \includegraphics[width=0.8\textwidth]{imagenes/nombre_figura.png}
  \caption{Topología del Escenario A — red plana perimetral.}
  \label{fig:escenario-a}
\end{figure}
```

**Opción B — placeholder** (si no tienes tiempo):
```latex
\begin{figure}[ht]
  \centering
  \fbox{\parbox{0.7\textwidth}{\centering\vspace{2cm}[FIG: Topología Escenario A]\vspace{2cm}}}
  \caption{Topología del Escenario A — red plana perimetral.}
  \label{fig:escenario-a}
\end{figure}
```

- [ ] Caps. 4 y 6 tienen más `[FIG:]` — empezar por ellos
- [ ] Usar Opción A solo si tienes ya la imagen lista; Opción B para el resto
- [ ] Los screenshots de `tests/img/` son candidatos directos para Cap. 6
- **Hecho cuando:** no hay `[FIG:]` sueltos en el texto (reemplazados todos por figura real o placeholder)

---

### Bloque 4 — 30 min · Compilación final y envío
- [ ] Compilar el PDF en Overleaf — resolver cualquier error de compilación que aparezca
- [ ] Revisar visualmente: portada, índice, que los `\cref{}` muestran "Sección X.Y", que las figuras aparecen
- [ ] Componer email al tutor (breve — ver plantilla en `docs/02_reuniones_tutor/00_DIRECTRICES_TUTOR.md §7`)
- [ ] **ENVIAR el email con el PDF adjunto antes de las 20:00**
- [ ] Registrar en `docs/02_reuniones_tutor/BITACORA_REUNIONES.md`
- **Hecho cuando:** el tutor tiene el PDF en su bandeja de entrada

---

## NO HACER HOY

- No reescribir texto ya redactado — solo maquetación
- No buscar más referencias de las estrictamente necesarias para quitar los `[CITAR:]`
- No perfeccionar figuras que ya tienen placeholder funcional
- No esperar respuesta del tutor antes de enviar — si no ha respondido, se envía igualmente

---

## CIERRE

Al terminar:
1. `git add docs/03_memoria_tfg/Borradores\ y\ pretrabajos/borradorplantillatfgoverleaf.tex && git commit -m "Overleaf: figuras, BibTeX y labels/cref — PDF final compilado"`
2. Copia el bloque `### 2026-06-20` de `admin/AGENDA_SPRINT_DIARIA.md` aquí para mañana.
3. Recuerda: **el 21/06 es el depósito en plataforma** — mañana es el último buffer de correcciones.
