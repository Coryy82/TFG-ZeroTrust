# Capítulo 4 — Diseño de la Solución

> **Estado:** ESQUELETO — redactar en semana 3 (09/06). Fuentes: `docs/01_investigacion/20260419_Prototipo_Red_Perimetral.md`, diarios de laboratorio `docs/04_diario_laboratorio/`, especificación Escenario B (a crear en 28-29/05).
> Criterio del tutor: el PORQUÉ de las decisiones de arquitectura es igual o más importante que el montaje técnico.
> Configuraciones extensas → Anexos.
> Objetivo de extensión: 10-14 páginas.

---

## 4.1 Visión general del sistema comparativo

[TODO] Diagrama de alto nivel de los dos escenarios. Describir que ambos sirven la misma aplicación web (Flask + PostgreSQL + Nginx), funcionalmente idénticos, con diferente modelo de red.

[FIG: diagrama comparativo Escenario A vs Escenario B — redes Docker, servicios, flujos de tráfico]

## 4.2 Escenario A — Arquitectura Perimetral

### 4.2.1 Topología de red

[TODO] Una única red Docker (`perimetral_net_interna`). Todos los contenedores (`webapp`, `backend`, `db`, `nginx`) comparten la misma red bridge. Visibilidad total entre servicios. Nginx como único punto de entrada externo.

[FIG: diagrama topología Escenario A — red plana, puertos, flujos]

### 4.2.2 Decisiones de diseño

[TODO] Por qué se eligió red plana: reproduce la configuración por defecto de la mayoría de despliegues Docker en producción real (es el escenario que se quiere mejorar). Ausencia intencional de SIEM, WAF activo o IDS (reproducing the "before" state).

### 4.2.3 Cadena de ataque (superficie de comparación)

[TODO] Los 4 hitos post-RCE que definen el denominador de comparación: (1) exfiltración de credenciales, (2) escaneo lateral, (3) acceso a backend/empleados, (4) volcado de base de datos. Ver `tests/00_PLANTILLA_KPI_v2.md §1.2.b`.

## 4.3 Escenario B — Arquitectura Zero Trust

### 4.3.1 Principios aplicados

[TODO] Cómo se traduce cada principio Zero Trust al diseño Docker concreto:
- "Nunca confíes, siempre verifica" → credenciales no compartidas, variables de entorno por servicio, sin contraseñas en variables de entorno globales.
- "Mínimo privilegio" → 3 redes Docker segregadas; cada contenedor solo accede a la red que necesita.
- "Verificación explícita" → mTLS entre webapp ↔ backend.
- "Asumir brecha" → Wazuh agent en `webapp` con reglas para los 4 hitos post-RCE.

### 4.3.2 Topología de red segmentada

[TODO] 3 redes Docker: `web_zone` (nginx + webapp), `backend_zone` (webapp + backend), `db_zone` (backend + db). Ningún contenedor tiene acceso directo a todos los demás. La `webapp` no puede conectar directamente a `db`.

[FIG: diagrama topología Escenario B — 3 zonas, políticas de conectividad, flujos permitidos/bloqueados]

### 4.3.3 mTLS entre webapp y backend

[TODO] Justificación: el tráfico `webapp → backend` es HTTP plano en el Escenario A (evidencia E3). En el Escenario B se protege con mTLS: certificados autofirmados generados con OpenSSL, Nginx (o Caddy) como proxy TLS en el contenedor `backend`. Solo `webapp` con el certificado cliente correcto puede conectar.

[FIG: diagrama mTLS — flujo de autenticación mutua, certs, CA]

### 4.3.4 Observabilidad activa — Wazuh

[TODO] Wazuh manager en contenedor dedicado + Wazuh agent en `webapp`. 3-5 reglas custom que detectan los 4 hitos post-RCE: (1) lectura de variables de entorno con credenciales, (2) nmap o escaneo interno, (3) curl a `/empleados` del backend, (4) conexión a `db:5432`. Cómo se mapea cada regla a G1 y G3.

### 4.3.5 Justificación de tecnología: Wazuh vs Suricata

[TODO] El diseño inicial del TFG (borrador pre-propuesta) contemplaba Suricata como sonda de red. Se eligió Wazuh por los siguientes motivos:
- Wazuh es host-based: detecta comandos y accesos dentro del contenedor comprometido, que es exactamente donde ocurren los 4 hitos post-RCE.
- Suricata es network-based: detecta patrones de tráfico, pero no comandos ejecutados dentro del contenedor.
- Para el modelo de amenazas definido (atacante con RCE en `webapp`), la detección host-based es más relevante que la detección network-based.
- Suricata queda como trabajo futuro para añadir una capa de detección network-level complementaria.

[CITAR: Wazuh documentation — host-based detection capabilities]

## 4.4 Tecnología utilizada

| Componente    | Tecnología            | Versión       | Justificación                                        |
|---------------|-----------------------|---------------|------------------------------------------------------|
| Infraestructura | Docker Compose      | v2            | Despliegue reproducible con un solo comando           |
| Aplicación web | Flask (Python)       | 3.x           | Stack ligero, SSTI Jinja2 como vector de ataque       |
| Base de datos  | PostgreSQL           | 15            | BBDD relacional estándar                             |
| Proxy web      | Nginx                | 1.25          | Reverse proxy, único punto de entrada externo         |
| mTLS           | OpenSSL + Nginx/Caddy | —            | Certificados autofirmados, sin dependencia de PKI     |
| SIEM/IDS       | Wazuh                | 4.x           | Host-based, agent Docker, reglas custom en YAML      |
| Fallback SIEM  | Falco                | —             | Network/syscall-based, criterio activación: 04/06 20:00 |

## 4.5 Limitaciones del diseño

[TODO] Honestas, no como excusa. Limitaciones que el tribunal puede preguntar:
- mTLS solo en un canal (webapp ↔ backend), no en todo el stack por coste temporal.
- Wazuh sin dashboard custom ni integraciones externas.
- Sin automatización de respuesta (SOAR): las alertas son pasivas, no bloquean automáticamente.
- Entorno local (no cloud): los resultados son representativos pero no directamente extrapolables a despliegues Kubernetes en producción.
