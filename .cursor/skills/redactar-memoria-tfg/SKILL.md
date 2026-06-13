---
name: redactar-memoria-tfg
description: Redacta, revisa o amplía texto de la memoria del TFG siguiendo la guía editorial ETSINF y el perfil de voz del autor. Usar siempre que se escriba, edite o revise contenido en docs/03_memoria_tfg/, incluyendo capítulos, borradores, bloques "Texto redactado" o revisiones de estilo de la memoria.
---

# Redacción de la memoria TFG

## Cuándo aplicar

Activar este flujo ante cualquier tarea de **redacción, revisión, ampliación o corrección de estilo** en `docs/03_memoria_tfg/`.

## Jerarquía de autoridad

1. **Máxima:** `docs/03_memoria_tfg/00_PAUTAS_IMPORTANTES_MEMORIA/Recomendaciones-Escritura-TFG.md` — guía editorial ETSINF.
2. **Voz del autor:** `docs/03_memoria_tfg/00_PAUTAS_IMPORTANTES_MEMORIA/perfil_escritura_autor.md` — estilo, rasgos y checklist.
3. **Estructura:** `docs/03_memoria_tfg/00_PAUTAS_IMPORTANTES_MEMORIA/EstucturayContenidodeunTFG.md` — cuando la tarea afecte a organización de apartados.

Si el perfil del autor choca con la guía ETSINF, **manda la guía**.

## Flujo obligatorio

```
Progreso:
- [ ] 1. Leer Recomendaciones-Escritura-TFG.md (al menos §Estilo personal, §Correcciones, §Código fuente, §Ilustraciones)
- [ ] 2. Leer perfil_escritura_autor.md (completo)
- [ ] 3. Leer el archivo destino y localizar bloques "Texto redactado"
- [ ] 4. Redactar o editar solo dentro de esos bloques
- [ ] 5. Validar contra la checklist del §7 del perfil
- [ ] 6. Marcar sugerencias de estilo con [REV-ESTILO: ...] fuera del contenido final
```

**Paso 1–2:** Leer ambas guías antes de escribir. No redactar de memoria.

**Paso 3–4:** El contenido fuera de bloques "Texto redactado" son anotaciones de esqueleto; no modificar salvo petición explícita.

**Paso 5:** Aplicar los 11 criterios del §7 de `perfil_escritura_autor.md`.

**Paso 6:** No reescribir prosa del autor sin su visto bueno; las observaciones van en `[REV-ESTILO: ...]`.

## Reglas editoriales esenciales

### Voz y tono (guía + perfil §1)

- Plural de autoría: "hemos representado", "diseñamos", "comprobamos". **Nunca** primera persona del singular.
- Lenguaje **denotativo**: preciso, sin interpretaciones libres ni creatividad estilística.
- Tono didáctico y procedimental: **porqué antes que cómo** (decisión → motivo → implementación → verificación).
- Público: tribunal ETSINF generalista; no asumir conocimiento del área.

### Estructura argumental (perfil §2)

- Concepto + implicación de seguridad o función en el experimento.
- Decisiones justificadas con contraste explícito frente a alternativas.
- Cierres de sección con síntesis que conecten con lo siguiente.
- Referencias cruzadas con `§X.Y`.

### Rasgos a preservar (perfil §5)

- Evidencia concreta: bytes, timestamps, nombres de fichero, comandos reales.
- Verificación operativa: comando + resultado esperado tras describir un control.
- Honestidad metodológica: limitaciones y matices, sin sobrevender.
- Encuadre comparativo A vs B.

### Rasgos a NO imitar (perfil §6)

Corregir, no propagar:

- Coloquialismos e idioms ("tumbar el entorno", "dan sus frutos", "favorece increíblemente").
- Run-on / comma splice.
- Sobre-negrita en párrafos enteros.
- Inconsistencias de terminología o puntuación.

### Contenido técnico (guía §Código fuente, §Ilustraciones)

- Mínimo código en el cuerpo; lo prescindible va a anexos.
- Figuras solo si son necesarias; numeradas, con leyenda/fuente y referenciadas en el texto.
- Sin maquetación ad-hoc ni separaciones manuales para inflar extensión.

### Artefactos prohibidos en texto final

- Notas de proceso, comentarios de agente o metadatos de borrador.
- Intensificadores subjetivos.
- Afirmaciones no justificables; enmarcar cifras de una sola sesión como tales.

## Checklist rápida (11 criterios)

Derivada del §7 de `perfil_escritura_autor.md`:

1. Voz impersonal o plural de autoría.
2. Lenguaje denotativo; sin intensificadores subjetivos ni idioms.
3. Sin coloquialismos; tecnicismos aclarados en primera mención.
4. Frases claras; sin run-on ni comma splice.
5. Ortografía y consistencia terminológica.
6. Mínimo código en cuerpo.
7. Figuras necesarias, numeradas y referenciadas.
8. Sin maquetación ad-hoc.
9. Público tribunal generalista.
10. Cero artefactos de proceso en texto final.
11. Precisión: no afirmar más de lo justificable.

## Ejemplo de voz correcta

> "Este escenario no pretende ser seguro; es la referencia contra la que medimos la mejora."

> "La profundidad del ataque pasa de tres nodos a uno: una reducción del 67 % en alcance lateral."

> "Los primeros intentos de ejecutar los scripts de captura en WSL fallaron con `env: $'bash\\r'`... Reescribimos los scripts con finales LF..."

## Recursos adicionales

- Decisiones de proyecto: `admin/DECISIONS_LOG.md` (ADR 2026-06-12 y 2026-06-13).
- Texto humano de referencia: `02_estado_arte.md` §2.7, `05_desarrollo_implantacion.md`, `06_pruebas.md`.
