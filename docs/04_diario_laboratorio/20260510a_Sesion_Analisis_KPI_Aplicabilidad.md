# Sesión de análisis — Aplicabilidad de KPIs validados al Escenario A actual

> **Fecha:** 10 de mayo de 2026
> **Propósito de este documento:** Registro narrativo e inmutable de la sesión en la que se cruzaron las **6 métricas validadas por el tutor** (correo del 2026-04-09 sobre el modelo de amenazas v2 del 2026-03-17) contra el estado real del Escenario A tras el refactor HTB-style del 2026-05-09, identificando huecos metodológicos y decidiendo el tratamiento para cada uno antes de iniciar la sesión de capturas.
>
> **Salida operativa:** [`tests/00_PLANTILLA_KPI.md`](../../tests/00_PLANTILLA_KPI.md) con las plantillas rellenables para cada escenario y el cuadro comparativo final.

---

## Índice

1. [Punto de partida](#1-punto-de-partida)
2. [Disparador del análisis](#2-disparador-del-análisis)
3. [Marco normativo: las 6 métricas validadas](#3-marco-normativo-las-6-métricas-validadas)
4. [Cruce con el estado actual del Escenario A](#4-cruce-con-el-estado-actual-del-escenario-a)
5. [Tratamiento de G1 y G3 — ausencia documentada](#5-tratamiento-de-g1-y-g3--ausencia-documentada)
6. [Tratamiento de E3 — captura tcpdump añadida a la cadena](#6-tratamiento-de-e3--captura-tcpdump-añadida-a-la-cadena)
7. [KPIs complementarios fuera del contrato académico](#7-kpis-complementarios-fuera-del-contrato-académico)
8. [Decisiones tomadas en esta sesión](#8-decisiones-tomadas-en-esta-sesión)
9. [Estado al cerrar la sesión](#9-estado-al-cerrar-la-sesión)

---

## 1. Punto de partida

Tras el refactor del 2026-05-09 ([20260509a_Sesion_Refactor_EscenarioA_HTB.md](20260509a_Sesion_Refactor_EscenarioA_HTB.md)), el Escenario A perimetral arranca correctamente y la cadena HTB-style se valida end-to-end. La sesión natural siguiente, según el `STATE.md`, es la captura de evidencias gráficas y la medición de KPIs.

Antes de empezar la captura conviene auditar **qué métricas son realmente medibles hoy** y **cuáles requieren un paso operativo añadido**, para no improvisar durante la sesión de captura.

Las fuentes de KPIs disponibles antes de esta sesión son tres, no una:

| Fuente | Métricas | Estatus académico |
|---|---|---|
| Correo Pau→Héctor del 2026-02-28 (validado el 2026-04-09) | 3 generales (G1, G2, G3) + 3 específicas (E1, E2, E3) | **Contrato con el tutor** |
| `docs/01_investigacion/20260419_Prototipo_Red_Perimetral.md` §8 | 6 KPIs operativos del prototipo | Material original, anterior al refactor |
| `docs/04_diario_laboratorio/20260509a_Sesion_Refactor_EscenarioA_HTB.md` §7 | 5 KPIs nuevos derivados del refactor | Complemento extra-contractual |

---

## 2. Disparador del análisis

Al revisar el plan de capturas surgió la duda:

> *"¿Las métricas que validó el tutor son medibles tal cual en el Escenario A actual, o hay que añadir pasos operativos? Y los KPIs nuevos que añadí en el doc del refactor, ¿están dentro o fuera del contrato académico?"*

Si esta auditoría no se hace antes de la captura, el riesgo es:

- Capturar evidencia que no responda a las métricas oficiales y descubrirlo después al redactar la memoria.
- Inflar el set de métricas con datos extra-contractuales que diluyen la comparativa principal.
- Llegar al tribunal con celdas vacías en G1 y G3 sin haber decidido cómo defenderlas.

---

## 3. Marco normativo: las 6 métricas validadas

| Cód. | Métrica | Tipo | Categoría |
|---|---|---|---|
| **G1** | Tiempo de Detección (segundos hasta que el sistema alerta) | General | Detección |
| **G2** | Profundidad del ataque (nº nodos internos alcanzados) | General | Impacto |
| **G3** | Tasa de bloqueo (% éxito de la contención automatizada) | General | Respuesta |
| **E1** | Superficie de Ataque Interna Visible | Específica | Visibilidad / movimiento lateral |
| **E2** | Volumen de datos fugados | Específica | Confidencialidad / robo de datos |
| **E3** | Integridad del flujo de tráfico | Específica | Integridad / MITM |

Estas 6 son el **único set con validación formal del tutor**. Cualquier otra métrica usada en este TFG es complementaria y debe etiquetarse como tal en la memoria.

---

## 4. Cruce con el estado actual del Escenario A

| Cód. | ¿Medible directamente? | Resultado esperado en perimetral | Observación |
|---|---|---|---|
| G1 | ❌ | ∞ / N/A | El Escenario A no tiene SIEM, IDS ni alertas. Tratamiento en §5. |
| G2 | ✅ | 3 nodos (webapp, backend, db) | Métrica limpia. |
| G3 | ❌ | 0% | El Escenario A no tiene contención automatizada. Tratamiento en §5. |
| E1 | ✅ | 100% (2/2 servicios internos visibles desde webapp) | Métrica limpia. |
| E2 | ✅ | tabla `empleados` (3 filas) + `DB_PASSWORD` + dump completo de la DB | Cuantificable. |
| E3 | ⚠️ | la cadena HTB no incluye MITM | Requiere paso operativo añadido. Tratamiento en §6. |

Resumen: **4 de 6 son medibles directamente. 2 dan "no-dato" estructural. 1 requiere añadir un paso operativo.**

---

## 5. Tratamiento de G1 y G3 — ausencia documentada

### 5.1 Concepto

G1 (detección) y G3 (contención automatizada) **carecen de mecanismo en el modelo perimetral por diseño**. El riesgo es que un dato vacío se lea como omisión metodológica.

La técnica de **ausencia documentada** convierte el vacío en evidencia: en lugar de afirmar *"no se midió"*, se afirma *"el mecanismo no existe en el modelo, por tanto la métrica adopta el valor convencional X por construcción"*. La ausencia ES el dato que justifica la introducción de Zero Trust.

### 5.2 Esquema de doble dimensión adoptado

Cada una de estas métricas se descompone en dos campos:

| Campo | Tipo | Significado |
|---|---|---|
| `mecanismo_existe` | bool | ¿La arquitectura implementa el mecanismo medido? |
| `valor` | numérico o convención | Si el mecanismo existe → medición real. Si no → valor convencional documentado. |

**Convenciones aplicadas:**

- G1 sin mecanismo → `valor = ∞` (notación equivalente a *MTTD = ∞ por diseño*; práctica habitual en frameworks de seguridad como NIST CSF cuando una organización carece de capacidad de detección).
- G3 sin mecanismo → `valor = 0%` (no se ejecuta ninguna contención, por tanto la tasa de éxito de contención es nula).

**Resultado esperado por escenario:**

| Métrica | Escenario A (perimetral) | Escenario B (Zero Trust) |
|---|---|---|
| G1 | `(false, ∞)` | `(true, X seg)` — Wazuh genera alerta correlacionada |
| G3 | `(false, 0%)` | `(true, X%)` — políticas mTLS, denegación de segmentación, etc. |

### 5.3 Alternativas evaluadas y descartadas

| Opción | Coste | Pros | Contras | Veredicto |
|---|---|---|---|---|
| Doble dimensión (`mecanismo_existe`, valor) | 0h técnico | Honesto, comparable, alineado con NIST CSF, transforma la ausencia en hallazgo estructural | Requiere párrafo explicativo en la memoria | **Elegido** |
| Proxy pasivo (logs nativos de nginx/Flask como "T_detección") | 1-2h | G1 finito en ambos escenarios | Asimetría conceptual: en perimetral mide trazabilidad pasiva, en ZT mide alertado activo | Descartado |
| Documentar ∞/0% sin más | 0h | Mínimo esfuerzo | Frágil ante "¿por qué no implementaste un mínimo de detección?" | Descartado |

### 5.4 Redacción sugerida para la memoria

> *"En el modelo perimetral, el tiempo de detección y la tasa de contención automatizada son indefinidos por construcción: la arquitectura no incluye ningún componente capaz de generar alertas (G1) ni de ejecutar respuestas automáticas (G3). Este resultado, lejos de constituir una limitación del experimento, documenta de forma cuantitativa una de las deficiencias estructurales del modelo perimetral frente al cual se contrastará el modelo Zero Trust en el Escenario B."*

---

## 6. Tratamiento de E3 — captura tcpdump añadida a la cadena

### 6.1 Estado

La cadena HTB-style implementada el 2026-05-09 no incluye MITM activo. La sección 7.5 del prototipo original lo planteaba como demostración opcional (`tcpdump -i eth0`).

### 6.2 Decisión

**Mantener E3 dentro del set validado mediante captura `tcpdump` durante el paso de movimiento lateral.**

Alternativas descartadas:

| Opción | Coste | Veredicto |
|---|---|---|
| Eliminar E3 del set y avisar al tutor | 0h técnico, ~30min comunicación | Reduce alcance prometido |
| Añadir captura `tcpdump` durante el paso lateral | ~30min en la sesión de capturas | **Elegido** |
| Reinterpretar E3 como "ausencia de cifrado interno verificada" estática | ~10min | Pierde la fuerza visual del `.pcap` con JSON legible |

### 6.3 Procedimiento operativo añadido a la sesión de capturas

1. Antes de ejecutar el payload SSTI que invoca `curl http://backend:5000/empleados`, abrir terminal adicional dentro del contenedor `webapp`:
   ```bash
   docker compose exec webapp sh -c "tcpdump -i any -w /tmp/lateral.pcap -c 50 host backend"
   ```
2. Lanzar el payload de movimiento lateral desde el navegador.
3. Detener `tcpdump` (`Ctrl+C` o automáticamente al alcanzar 50 paquetes).
4. Copiar el `.pcap` al host:
   ```bash
   docker compose cp webapp:/tmp/lateral.pcap tests/logs/20260510_lateral_perimetral.pcap
   ```
5. Verificar con Wireshark: el JSON con datos de empleados debe ser legible en texto plano.

**Resultado esperado en perimetral:** `.pcap` con payload HTTP claro y JSON de `empleados` legible.
**Resultado esperado en ZT:** `.pcap` con handshake TLS y payload cifrado ilegible (o conexión rechazada por mTLS si el cliente no presenta certificado válido).

---

## 7. KPIs complementarios fuera del contrato académico

Estos KPIs no forman parte del contrato con el tutor pero enriquecen la trazabilidad operativa. Se documentan en la sección de evidencia operativa de cada captura, **no en el cuerpo principal de la memoria**.

### 7.1 Timings granulares por paso de la cadena

| Cód. | Hito de la cadena | Sub-medida de |
|---|---|---|
| T0 | Inicio de la sesión de ataque | (referencia) |
| T_recon_http | Banner grabbing con `curl -I` | G1 / E1 |
| T_recon_rutas | Lectura de `/robots.txt` | G1 / E1 |
| T_disclosure | Lectura de `/backup.txt` con credenciales | G1 / E2 |
| T_auth | POST login → 302 + cookie | G1 |
| T_ssti_detect | Confirmación SSTI con `{{7*7}}` → 49 | G1 |
| T_rce | RCE confirmada con `popen('id')` → uid=0 | G1 / G2 |
| T_exfil_creds | Exfiltración de `DB_PASSWORD` con `popen('env')` | E2 |
| T_lateral | Movimiento lateral con `popen('curl backend')` | G2 / E1 / E3 |
| T_objetivo | Dump completo de la DB con `psql -h db` | G2 / E2 |

### 7.2 KPIs adicionales del refactor 09/05

| Métrica | Categoría |
|---|---|
| Nº de pasos previos al RCE | Complejidad del ataque (contextual) |
| Nº de endpoints públicos que filtran información | Sub-medida de E1 |
| Nº de CWE distintos materializables | Material para marco teórico |

---

## 8. Decisiones tomadas en esta sesión

1. **Las 6 métricas validadas por el tutor son el único contrato académico.** Cualquier otra métrica se etiqueta como complementaria.
2. **G1 y G3 se miden con esquema de doble dimensión** `(mecanismo_existe, valor)`. En perimetral resultan `(false, ∞)` y `(false, 0%)` respectivamente.
3. **E3 se mantiene en el set añadiendo un paso operativo de `tcpdump`** durante el movimiento lateral.
4. **Los 10 timings granulares y los KPIs del refactor 09/05 se registran como evidencia operativa anexa**, no como métricas oficiales.
5. **La plantilla rellenable se materializa en `tests/00_PLANTILLA_KPI.md`** para ser usada en la sesión de captura inmediatamente posterior.

---

## 9. Estado al cerrar la sesión

### Salida operativa generada

- `tests/00_PLANTILLA_KPI.md` — plantilla rellenable con tres secciones:
  1. Plantilla de captura para Escenario A (perimetral).
  2. Plantilla de captura para Escenario B (Zero Trust).
  3. Cuadro comparativo final.

### Pendiente (siguiente sesión)

- Ejecutar `docker compose up --build` y guardar log en `tests/logs/20260510_docker_compose_up.log`.
- Ejecutar la cadena HTB-style end-to-end con capturas de pantalla y rellenar `tests/00_PLANTILLA_KPI.md` §1.
- Lanzar `tcpdump` durante el movimiento lateral y guardar `.pcap` para E3.
- Cierre de tareas D2, T2, T3 del tablero del sprint.

### Documentación derivada

Esta sesión deja claro el porqué de cada decisión metodológica antes de empezar la captura. Las decisiones 2 y 3 son candidatas a ir a `admin/DECISIONS_LOG.md` por su impacto en el contrato académico.
