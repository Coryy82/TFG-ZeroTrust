# Capítulo 5 — Desarrollo e Implantación

> **Estado:** ESQUELETO — redactar en semana 3 (12-13/06). Fuente primaria: `docs/04_diario_laboratorio/` (sesiones inmutables).
> Criterio del tutor (§2): documentar DECISIONES y RESULTADOS relevantes, no cada cambio menor.
> Configuraciones completas (docker-compose.yml, reglas Wazuh, certs) → Anexos.
> Objetivo de extensión: 10-14 páginas.

---

## 5.1 Infraestructura como código (IaC)

[TODO] Breve descripción del enfoque: todo el entorno está definido en ficheros de configuración versionados en Git. `docker-compose.yaml` como orquestador. Reproducibilidad como principio: cualquier sesión de captura empieza con `docker compose up --build -d`.

## 5.2 Implementación del Escenario A (Perimetral)

### 5.2.1 Estructura de la aplicación

[TODO] 4 servicios: `nginx` (reverse proxy), `webapp` (Flask + Jinja2 con SSTI deliberada), `backend` (Flask API de empleados), `db` (PostgreSQL con datos de ejemplo). Referencia al diseño: `docs/01_investigacion/20260419_Prototipo_Red_Perimetral.md`.

### 5.2.2 Vectores de vulnerabilidad implementados

[TODO] Descripción de las vulnerabilidades intencionales (cada una mapeada a un CWE):
- CWE-200: `robots.txt` con rutas internas expuestas.
- CWE-522 / CWE-798: `backup.txt` con credenciales en texto claro.
- CWE-306: Panel de administración sin protección adicional de acceso.
- CWE-1336: SSTI Jinja2 en el parámetro `host` del panel de diagnóstico.

[CITAR: OWASP CWE-1336 — Server Side Template Injection]

### 5.2.3 Decisiones de implementación relevantes

[TODO] Extracto filtrado de los ADRs y diarios:
- ADR 2026-05-09: elección de SSTI Jinja2 vs SQLi vs File Upload. Por qué SSTI.
- ADR 2026-05-10: esquema G1/G3 como tupla `(mecanismo_existe, valor)`.
- ADR 2026-05-12: separación pre-RCE / post-RCE en plantilla KPI v2.
Ver `admin/DECISIONS_LOG.md` para trazabilidad completa.

### 5.2.4 Protocolo de captura de evidencias

[TODO] Descripción del script `tests/scripts/logcapture_perimetral.sh` (flujo de 5 pasos). Sesión oficial: `perimetral_sesion_20260523_175204`. Los artefactos se encuentran en `tests/logs/perimetral_sesion_20260523_175204/`.

## 5.3 Implementación del Escenario B (Zero Trust)

> **Nota:** este capítulo se completa una vez implementado el Escenario B (02-05/06).
> Los siguientes apartados son placeholders con la especificación de diseño.

### 5.3.1 Segmentación de redes

[TODO POST-IMPL] Descripción de las 3 redes Docker creadas. Qué contenedor pertenece a qué red. Cómo se verifica que la segmentación bloquea el acceso directo `webapp → db`.

### 5.3.2 Identidad de servicio y credenciales

[TODO POST-IMPL] `.env` por servicio. Sin credenciales compartidas. Descripción de la rotación de variables de entorno entre escenarios.

### 5.3.3 Implementación de mTLS

[TODO POST-IMPL] Generación de CA y certificados con OpenSSL. Configuración de Nginx/Caddy como proxy TLS en `backend`. Configuración del cliente en `webapp` para presentar certificado. Verificación de la conexión cifrada (evidencia E3 Escenario B).

[FIG: fragmento de configuración Nginx mTLS — referencia a Anexo X para configuración completa]

### 5.3.4 Despliegue de Wazuh

[TODO POST-IMPL] Manager en contenedor dedicado. Enrollment del agent en `webapp`. Las 3-5 reglas custom (texto de la regla YAML + descripción de qué detecta). Cómo se verifica que una alerta se genera (log de Wazuh manager).

## 5.4 Problemas de integración encontrados

[TODO] Sección concreta: 3-5 problemas reales encontrados durante el desarrollo y cómo se resolvieron. Usar los diarios de laboratorio como fuente. Ejemplos previstos:
- Error CRLF en `logcapture_perimetral.sh` → solución: `dos2unix`.
- `dump.txt` y `lateral.pcap` a 0 bytes en primera sesión de prueba → solución: integrar `docker compose cp` en el script antes de `compose down`.
- [TODO POST-IMPL: problemas reales del Escenario B]

[INSUMO: `docs/04_diario_laboratorio/20260523a_Sesion_Cierre_Baseline_EscenarioA.md §4`]
