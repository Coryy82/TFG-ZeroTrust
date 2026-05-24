# HOY — 2026-05-25 (lunes)

> Actualizar este archivo cada mañana copiando el bloque del día desde `admin/AGENDA_SPRINT_DIARIA.md`.
> Plan ID: `redactar_eda_v0` (parcial)
> Fase: 1 de 4 · Semana 1 · Día 2 del sprint

---

## OBJETIVO DEL DÍA

Escribir las dos primeras secciones del Estado del Arte.  
Cuando termines, el capítulo tendrá texto real en §2.1 y §2.2.

---

## SI SOLO HACES UNA COSA

**Redacta §2.1** de `docs/03_memoria_tfg/02_estado_arte.md` hasta que tenga al menos 3 párrafos sólidos sobre la evolución de contenedores y por qué las redes planas son un problema de seguridad.  
Eso solo ya hace avanzar el camino crítico.

---

## BLOQUES DE TRABAJO

### Bloque 1 — 45 min
- [ ] Abre `docs/03_memoria_tfg/02_estado_arte.md`
- [ ] Lee el `[TODO]` de §2.1 y el insumo `docs/01_investigacion/20260412_Apuntes_Docker101.md`
- [ ] Sustituye el bloque `[TODO]` de §2.1 por texto real: evolución monolítico → microservicios → Docker → red plana por defecto → implicación de seguridad
- [ ] Añade al menos un marcador `[CITAR: Docker networking / paper seguridad contenedores]`
- **Hecho cuando:** §2.1 tiene ≥3 párrafos sin `[TODO]` sin resolver

### Bloque 2 — 40 min
- [ ] Sustituye el `[TODO]` de §2.2 por texto real: definición del modelo perimetral, por qué funciona contra amenazas externas, por qué falla post-compromiso
- [ ] Añade marcador `[CITAR: NIST SP 800-207 §1]`
- **Hecho cuando:** §2.2 tiene ≥2 párrafos y termina con la frase-puente hacia ZT

### Bloque 3 — 15 min
- [ ] Abre `docs/03_memoria_tfg/99_bibliografia.md`
- [ ] Añade estas 2 entradas con formato IEEE placeholder:
  - NIST SP 800-207 (URL: https://doi.org/10.6028/NIST.SP.800-207)
  - Docker networking documentation (URL: https://docs.docker.com/network/)
- **Hecho cuando:** las 2 entradas están en el fichero con URL

---

## NO HACER HOY

- No tocar §2.3 ni secciones siguientes (eso es mañana)
- No reescribir el skeleton de otros capítulos
- No buscar más de 2 referencias (el tiempo de búsqueda es una trampa)
- No instalar ni tocar Docker ni el Escenario B (eso es el 02/06)
- No revisar lo que ya está bien: añade `[REVISAR]` y sigue

---

## CIERRE

Al terminar los 3 bloques:
1. Guarda todos los archivos.
2. Haz `git add docs/03_memoria_tfg/02_estado_arte.md docs/03_memoria_tfg/99_bibliografia.md && git commit -m "EdA: redactar §2.1 y §2.2 (contenedores + modelo perimetral)"`.
3. Abre `admin/AGENDA_SPRINT_DIARIA.md`, localiza el bloque `2026-05-26` y copia su contenido en este archivo para mañana.
