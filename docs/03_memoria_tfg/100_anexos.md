# Anexos

> **Estado:** ESQUELETO — apartado **Opcional** según la pauta ETSINF, pero **exigido por el tutor** para las configuraciones extensas (`docs/02_reuniones_tutor/00_DIRECTRICES_TUTOR.md` §2: "configuraciones extendidas → Anexos, no en el cuerpo principal").
> **Propósito:** recoger el material técnico que no es necesario leer en el cuerpo para entender la memoria, pero que aporta trazabilidad y reproducibilidad. Los capítulos 4–6 remiten "al anexo"; aquí es donde aterrizan esas remisiones.
> **Pendiente:** volcar los ficheros/fragmentos reales desde `infra/` y `tests/` en la pasada a Overleaf. No pegar configuraciones completas en el cuerpo de la memoria.

---

## Anexo A — Configuración del Escenario A (Perimetral)

[TODO] `docker-compose.yaml` del Escenario A (redes `net_dmz` / `net_interna`, 4 servicios). Fuente: `infra/perimetral/`.

## Anexo B — Configuración del Escenario B (Zero Trust)

[TODO] `docker-compose.yaml` con las 3 zonas (`web_zone`, `backend_zone`, `db_zone`). Fuente: `infra/zero_trust/`.

[TODO] `nginx.conf` del PEP mTLS en `backend` (`ssl_verify_client on`, `proxy_pass` a Flask en loopback). Referenciado desde §5.3.3.

[TODO] Generación de CA y certificados (OpenSSL): comandos `serverAuth` / `clientAuth`. Referenciado desde §4.3.3 y §5.3.3.

## Anexo C — Reglas de detección Wazuh

[TODO] `local_rules.xml` (reglas 100100–100104) y fragmento relevante de `ossec.conf` (fuente `process-webapp`, muestreo 2 s). Referenciado desde §4.3.4 y §5.3.4.

## Anexo D — Scripts de captura de evidencias

[TODO] `logcapture_perimetral.sh` y `logcapture_zerotrust.sh`. Referenciados desde §5.1 y §6.1.1.

## Anexo E — Plantilla de KPIs y evidencias de sesión

[TODO] `tests/00_PLANTILLA_KPI_v2.md` (§1 Escenario A, §2 Escenario B, §3 comparativa) y listado de artefactos por sesión (`creds.txt`, `lateral.json`, `lateral.pcap`, `dump.txt`, `e1_scan.log`, `wazuh_alerts.json`).

## Anexo F — Capturas de pantalla complementarias

[TODO] Capturas no incluidas en el cuerpo (figuras `[FIG:]` secundarias de los Cap. 5 y 6).
