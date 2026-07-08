# Imágenes del TFG (formato JPG)

Coloca aquí cada archivo con el nombre exacto indicado. El documento principal
(`DocumentoFinalOverleaf.tex`) referencia `img/<nombre>.jpg`.

El código de \texttt{app.py} (webapp y backend) e \texttt{init.sql} figura en
`anexos/` y se incluye vía `\lstinputlisting` en el anexo \texttt{anexo:codigo\_aplicacion}.

## Capítulo 4 — Diseño

| Archivo | Contenido |
|---------|-----------|
| `cap04-arquitectura-microservicios.jpg` | Pila nginx/webapp/backend/db y tecnologías |
| `cap04-flujo-microservicios.jpg` | Cadena webapp→backend→db con puertos |
| `cap04-topologia-perimetral.jpg` | Topología Escenario A (net_dmz + net_interna) |
| `cap04-topologia-zerotrust.jpg` | Topología Escenario B (3 zonas) |
| `cap04-mtls-handshake.jpg` | Secuencia mTLS webapp↔backend |
| `cap04-wazuh-zerotrust.jpg` | Integración Wazuh en el stack ZT |

## Capítulo 5 — Desarrollo

| Archivo | Contenido |
|---------|-----------|
| `nginxconf.jpg` | \texttt{nginx.conf} del proxy de entrada (puerto 80) |
| `cap05-dockerfile.jpg` | Dockerfile webapp/backend |
| `cap05-pre-rce-escaneo.jpg` | Reconocimiento HTTP pre-RCE |
| `cap05-pre-rce-robots.jpg` | curl robots.txt |
| `cap05-pre-rce-backup.jpg` | curl backup.txt |
| `cap05-pre-rce-dashboard.jpg` | Panel de administración |
| `cap05-pre-rce-ssti.jpg` | SSTI / RCE en diagnóstico |
| `cap05-compose-nginx.jpg` | Fragmento compose — servicio nginx |
| `cap05-compose-webapp.jpg` | Fragmento compose — servicio webapp (build y redes) |
| `cap05-compose-redes.jpg` | Redes definidas en compose perimetral |
| `cap05-zt-compose-networks.jpg` | Sección networks del compose ZT |
| `cap05-zt-segmentacion-test.jpg` | Output verificación segmentación |
| `cap05-zt-webapp-env.jpg` | BACKEND_URL sin credenciales DB |
| `cap05-mtls-openssl.jpg` | Generación CA/certificados OpenSSL |
| `cap05-mtls-volumes.jpg` | Volúmenes de certificados en compose |
| `cap05-mtls-nginx-conf.jpg` | nginx.conf del backend (PEP mTLS) |
| `cap05-mtls-webapp-client.jpg` | Cliente HTTPS/mTLS en webapp |
| `cap05-mtls-verificacion.jpg` | curl con/sin certificado (output); también evidencia lateral fallido en cap. 6 |
| `cap05-wazuh-despliegue.jpg` | Despliegue Wazuh (compose / agente) |
| `cap05-docker-compose-up.jpg` | docker compose up — contenedores activos |

## Capítulo 6 — Pruebas

### Escenario A (Perimetral)

| Archivo | Contenido |
|---------|-----------|
| `cap06-nmap-perimetral.jpg` | nmap interno desde webapp |
| `cap06-exfil-empleados.jpg` | Petición /empleados — JSON exfiltrado |
| `cap06-exfil-sql.jpg` | Consulta SQL / volcado BD |
| `cap06-tcpdump-pcap.jpg` | tcpdump / tráfico en claro (pcap) |

### Escenario B (Zero Trust)

La alerta Wazuh regla 100100 (G1) figura como \texttt{lstlisting} en el cap. 6, no como imagen.

| Archivo | Contenido | Fuente sugerida en logs |
|---------|-----------|-------------------------|
| `cap06-nmap-zerotrust.jpg` | nmap interno desde webapp (`db` no resuelve) | `e1_scan.log` |
| `cap06-tcpdump-zt.jpg` | tcpdump / pcap solo TLS | `lateral.pcap` |
