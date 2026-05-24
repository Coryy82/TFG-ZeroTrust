# Capítulo 3 — Análisis del Problema

> **Estado:** ESQUELETO — redactar en semana 3 fase intensiva (12-13/06).
> Fuente principal: `docs/02_reuniones_tutor/00_DIRECTRICES_TUTOR.md §3` (modelo de amenazas validado).
> El modelo de amenazas v2 fue validado por el tutor el 09/04/2026. No reescribir la lógica, solo expandir.
> Objetivo de extensión: 6-8 páginas.

---

## 3.1 Descripción del problema

[TODO] Formalizar el problema que motiva el TFG: las infraestructuras de microservicios en Docker heredan configuraciones de red planas que, una vez comprometido un servicio externo, permiten al atacante moverse libremente por la red interna sin ningún mecanismo de contención ni detección activa.

## 3.2 Modelo de amenazas

El modelo de amenazas fue definido y validado por el tutor Héctor el 09/04/2026 (ver `docs/02_reuniones_tutor/00_TIMELINE_CORREOS.md` §11–§12). Se recoge aquí verbatim como marco del estudio.

### 3.2.1 Asunciones sobre el atacante

- Atacante externo, no privilegiado.
- Ha logrado explotar una vulnerabilidad en el servicio web y obtiene ejecución de código remota (RCE).
- No tiene acceso físico al host ni credenciales de administración de red.

### 3.2.2 Activos a proteger

- Base de datos (`db`): datos de empleados, credenciales almacenadas.
- Código fuente del backend y archivos de configuración (`.env` con credenciales de base de datos).

### 3.2.3 Superficie de estudio

- Red interna de contenedores Docker.
- Comunicaciones inter-servicio: `webapp ↔ backend`, `backend ↔ db`.

### 3.2.4 Amenazas en alcance

- **Movimiento lateral:** acceso desde `webapp` comprometida a servicios internos (`backend`, `db`) no expuestos externamente.
- **Interceptación de tráfico interno:** lectura de datos en tránsito entre servicios (sin cifrado, HTTP plano).
- **Exfiltración de datos:** extracción de credenciales de base de datos y volcado de tablas hacia el exterior.

### 3.2.5 Amenazas fuera del alcance

- Ingeniería social y ataques de phishing.
- Seguridad física del host.
- Vulnerabilidades del kernel del sistema operativo subyacente.
- Ataques de denegación de servicio (DoS/DDoS).
- Vectores no relacionados con la microsegmentación de la red interna.

## 3.3 Especificación de requisitos

### 3.3.1 Requisitos funcionales

| ID   | Requisito                                                                                       |
|------|-------------------------------------------------------------------------------------------------|
| RF-1 | El sistema debe reproducir una cadena de ataque real (recon → info disclosure → login → RCE).  |
| RF-2 | El sistema debe medir los 6 KPIs (G1–G3, E1–E3) de forma comparable entre Escenario A y B.    |
| RF-3 | El Escenario B debe bloquear o detectar los 4 hitos post-RCE del Escenario A.                  |
| RF-4 | Las evidencias de cada escenario deben ser reproducibles y verificables (logs, pcap, scripts). |

### 3.3.2 Requisitos no funcionales

| ID    | Requisito                                                                                        |
|-------|--------------------------------------------------------------------------------------------------|
| RNF-1 | Despliegue automatizado mediante `docker compose up` en un solo comando.                        |
| RNF-2 | El entorno debe ejecutarse en hardware de escritorio (sin infraestructura cloud).               |
| RNF-3 | Las capturas de evidencia deben almacenarse de forma estructurada y reproducible.               |
| RNF-4 | El código de infraestructura debe ser mantenible y versionado en Git.                           |

## 3.4 Definición de métricas (KPIs)

Los 6 KPIs fueron definidos en coordinación con el tutor y formalizados en `tests/00_PLANTILLA_KPI_v2.md`. Se recogen aquí con su definición operativa.

| Código | Nombre                        | Definición                                                                          | Escenario A     | Escenario B (esperado)   |
|--------|-------------------------------|-------------------------------------------------------------------------------------|-----------------|--------------------------|
| G1     | Tiempo de detección (MTTD)    | Tupla `(mecanismo_existe: bool, valor: segundos∣∞)`. Tiempo desde T0_efectivo hasta alerta activa. | `(false, ∞)`    | `(true, X s)`            |
| G2     | Profundidad del ataque        | Número de nodos internos alcanzados desde `webapp` post-RCE.                       | 3 nodos         | ≤1 nodo (esperado)       |
| G3     | Tasa de bloqueo               | Tupla `(mecanismo_existe: bool, valor: %)`. Porcentaje de hitos post-RCE bloqueados. | `(false, 0%)`   | `(true, Y%)`             |
| E1     | Superficie interna visible    | Número de servicios internos visibles/accesibles desde `webapp` post-RCE.          | 3/3 servicios   | ≤1 (esperado)            |
| E2     | Volumen de datos exfiltrados  | Volumen y naturaleza de los datos extraídos (registros, archivos, bytes).           | 3 reg + 1 cred / ~766B | 0 reg / 0B (esperado) |
| E3     | Integridad del tráfico interno| Protocolo de la comunicación inter-contenedor: `texto claro` vs `TLS/rechazado`.   | `texto claro`   | `TLS` o `rechazado`      |

> **T0_efectivo:** instante en que el atacante dispone de shell post-RCE operativa en `webapp`. Todos los Δ comparativos se miden desde este instante. Ver `tests/00_PLANTILLA_KPI_v2.md §1.2.b`.
