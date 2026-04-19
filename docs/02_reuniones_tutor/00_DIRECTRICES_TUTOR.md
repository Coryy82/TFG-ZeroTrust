# Directrices y Expectativas del Tutor (Héctor)

Estas reglas dictadas por el tutor deben respetarse estrictamente en la redacción y ejecución del TFG:

## 1. Enfoque General del Documento (CRÍTICO)
- **Seguridad vs. Infraestructura:** El documento debe leerse como un "Análisis de Seguridad", NO como un manual de "Arquitectura/Despliegue".
- **Límite de detalle técnico:** Reducir al mínimo imprescindible las explicaciones de "cómo montar Docker".
- **Foco principal:** Centrar el texto en qué se ataca, qué se mide, y por qué Zero Trust mejora (o no) la defensa frente a la perimetral.

## 2. Marco del Modelo de Amenazas (Threat Model)
Cualquier referencia al modelo de amenazas en la memoria debe estructurarse obligatoriamente en estos 5 puntos:
1. **Asunciones del atacante:** Atacante externo, no privilegiado, con ejecución de código remota (RCE) en servicio Web. Sin acceso físico ni credenciales de admin de red.
2. **Activos a proteger:** Base de datos y código fuente del backend (archivos .env).
3. **Superficie de estudio:** Red interna de contenedores.
4. **Amenazas en alcance:** Movimiento lateral, interceptación de tráfico interno, exfiltración de datos.
5. **Amenazas fuera de alcance:** Ingeniería social, seguridad física, vulnerabilidades del kernel host.

## 3. Pruebas y Métricas
- Las métricas deben ser **estrictamente comparables** entre ambos escenarios (Perimetral vs Zero Trust).
- Las pruebas deben simular escenarios de *post-explotación* (una vez la vulnerabilidad inicial ya ha sido aprovechada).

## 4. Dudas Pendientes de Resolución (Para Héctor)
- ¿Cómo documentar la fase de laboratorio? (¿Diario exhaustivo vs. Resultado final?).
- ¿Cómo gestionar la bibliografía durante la investigación empírica?