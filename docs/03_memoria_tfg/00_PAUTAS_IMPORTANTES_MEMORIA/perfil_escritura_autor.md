# Perfil de escritura del autor (Pau)

> **Propósito:** que cualquier agente que redacte o revise texto de la memoria mantenga coherencia con la voz del autor.
> **Autoridad:** este documento es subordinado a [`Recomendaciones-Escritura-TFG.md`](Recomendaciones-Escritura-TFG.md), que tiene prioridad máxima en redacción (ADR 2026-06-13 en `admin/DECISIONS_LOG.md`). Cuando el estilo del autor choque con la guía ETSINF, manda la guía.
> **Fuentes del perfil (solo texto humano):** `05_desarrollo_implantacion.md` (todo), `06_pruebas.md` (todo), `02_estado_arte.md` §2.7 y las reescrituras marcadas `> HUMANO:` en §2.2-§2.6.
> **Regla de esqueleto:** solo pasa a la memoria final el contenido dentro de los bloques "Texto redactado". El resto son anotaciones.

---

## 1. Perfil de estilo

- **Voz:** primera persona del plural (plural de autoría). Verbos recurrentes: "hemos representado", "automatizamos", "sustituimos", "comprobamos", "medimos", "desplegamos", "diseñamos". Nunca primera persona del singular. Alineado con la guía (líneas 84-86).
- **Tono:** didáctico y procedimental. Patrón dominante: *porqué antes que cómo* — primero la decisión y su motivo, después la implementación y su verificación.
- **Sintaxis:** frase de longitud media-larga. Tendencia a encadenar cláusulas con comas (a veces deriva en run-on / comma splice, que es un rasgo a corregir, no a imitar).
- **Párrafo:** corto a medio; una idea o un comando de verificación por bloque.

## 2. Estructura argumental

- **Introducción de conceptos:** se enuncia el concepto y de inmediato su implicación de seguridad o su función en el experimento.
- **Justificación de decisiones:** se explicita el motivo y el contraste con la alternativa ("Elegimos DMZ más red interna porque reproduce una práctica habitual...").
- **Comparación de alternativas:** contraste explícito A vs B, con "en cambio", "como en el caso anterior", enumeraciones paralelas.
- **Cierre de sección:** frase de síntesis que conecta con lo siguiente ("En conjunto, estos resultados cuantifican un patrón que la literatura revisada en §2.7 apenas aborda con métricas comparables.").

## 3. Rasgos distintivos

- **Conectores frecuentes:** "Asimismo", "Sin embargo", "Además de esto", "Para ello", "De este modo", "En cambio", "En conjunto", "A partir de ahí".
- **Evidencia concreta:** datos medibles incrustados en la prosa — bytes (`~766 B`), timestamps, nombres de fichero (`creds.txt`, `lateral.pcap`), comandos reales.
- **Verificación operativa:** tras describir un control, muestra el comando que lo comprueba y el resultado esperado (patrón muy presente en Caps. 5 y 6).
- **Referencias cruzadas:** remite a otras secciones con `§X.Y`.
- **Aclaraciones entre paréntesis** para matizar sin romper la frase.

## 4. Ejemplos reales (texto del autor)

- **Cierre comparativo con evidencia** (`06_pruebas.md` §6.4.2): "La profundidad del ataque pasa de tres nodos a uno: una reducción del 67 % en alcance lateral."
- **Decisión + motivo + contraste** (`04_diseno.md` §4.2.2, texto que el autor mantiene): "Este escenario no pretende ser seguro; es la referencia contra la que medimos la mejora."
- **Honestidad metodológica** (`06_pruebas.md` §6.4.3): "en A no hay SIEM por diseño, así que comparar la latencia de la primera alerta en B no es un duelo equitativo".
- **Posicionamiento frente a la literatura** (`02_estado_arte.md` §2.7): "Este trabajo se sitúa en ese hueco. La pregunta que guía el estudio no es simplemente si dos despliegues son distintos, sino en qué medida una arquitectura Zero Trust... reduce el impacto de ataques post-explotación...".
- **Trazabilidad de incidencias** (`05_desarrollo_implantacion.md` §5.5): "Los primeros intentos de ejecutar los scripts de captura en WSL fallaron con `env: $'bash\\r'`... Reescribimos los scripts con finales LF...".

## 5. Elementos a preservar

- El relato *porqué antes que cómo* y las decisiones justificadas frente a alternativas.
- Las limitaciones honestas y los matices de interpretación (no sobrevender).
- La evidencia concreta (bytes, timestamps, comandos, ficheros).
- El encuadre comparativo A vs B y los cierres de síntesis.
- El plural de autoría.

## 6. Rasgos a NO imitar (corregir, no propagar)

Son defectos detectados en el texto humano; un agente NO debe reproducirlos al continuar:

- **Coloquialismos / idioms:** "tumbar el entorno" (`05` §5.2.4), "dan sus frutos" (`06` §6.3), "favorece increíblemente" (`02` §2.2), "chocaba".
- **Run-on / comma splice:** frases largas encadenadas con comas (`02` §2.3 HUMANO).
- **Sobre-negrita:** envolver párrafos enteros en `**...**` (`06` §6.1).
- **Inconsistencias menores:** "docker" en minúscula, "Reverse Shell"/"Assumed breach" entrecomillados e inconsistentes, frases sin punto final.

## 7. Checklist editorial reutilizable (11 criterios)

> Aplicar a todo bloque "Texto redactado" antes de darlo por bueno. Derivada de [`Recomendaciones-Escritura-TFG.md`](Recomendaciones-Escritura-TFG.md).

1. Voz impersonal o plural de autoría; nunca primera persona del singular (guía 84-86).
2. Lenguaje denotativo: sin intensificadores subjetivos ("increíblemente") ni idioms ("dan sus frutos") (guía 84, 88).
3. Sin coloquialismos; tecnicismos aclarados en primera mención (guía 88-92).
4. Frases no barrocas; sin run-on ni comma splice; puntuación correcta (guía 120).
5. Ortografía y consistencia (mayúsculas de nombres propios, terminología uniforme) (guía 118-120).
6. Mínimo código en el cuerpo; lo prescindible va a anexos (guía 108-114).
7. Figuras necesarias, numeradas, con leyenda/fuente y referenciadas en el texto (guía 76-80).
8. Sin maquetación ad-hoc ni separaciones manuales de párrafo para inflar (guía 96-98, 124).
9. Público objetivo = tribunal generalista; no asumir conocimiento del área (guía 92).
10. Cero artefactos de proceso en el texto que pasa a final (derivado del propósito de documento oficial, guía 7).
11. Precisión: no afirmar más de lo justificable; enmarcar cifras de una sola sesión como tales (rigor profesional, guía 7).

## 8. Recomendaciones para futuros agentes

- Antes de redactar, leer la guía editorial y este perfil; contrastar el resultado contra la checklist del §7.
- Al continuar prosa, imitar los rasgos del §5 y evitar los del §6.
- No tocar texto fuera de los bloques "Texto redactado" (son anotaciones de esqueleto).
- Las sugerencias de estilo se marcan con `[REV-ESTILO: ...]` fuera del contenido final; no reescribir prosa del autor sin su visto bueno.

---

**Referencias cruzadas:** [`Recomendaciones-Escritura-TFG.md`](Recomendaciones-Escritura-TFG.md) (autoridad editorial), [`EstucturayContenidodeunTFG.md`](EstucturayContenidodeunTFG.md) (autoridad estructural), `admin/DECISIONS_LOG.md` (ADR 2026-06-12 y 2026-06-13).
