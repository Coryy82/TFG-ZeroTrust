# Introducción
## Motivación
El aumento de ciberataques y el creciente costo que esto está suponiendo en la economía global año tras año y la ineficacia de los perímetros tradicionales obligan a reforzar la seguridad interna.
## Objetivos
El objetivo principal es diseñar dos arquitecturas idénticas, perímetro convencional y Zero Trust, y someterlas a una auditoría comparativa.
Otros objetivos incluyen el despliegue automatizado de las infraestructuras o la implementación de políticas de red automáticas.
## Metodología
Se buscará una metodología experimental e iterativa. Se irán desarrollando prototipos de la red y se validarán para ajustar la configuración de las defensas.
## Estructura de la memoria
Breve resumen de los capítulos
# Estado del arte
En este apartado se estudiará la evolución desde servidores monolíticos hasta la contenerización con Docker o Kubernetes. Se analizará cómo la “comodidad” de las redes planas en contenedores ha creado nuevas vulnerabilidades de seguridad.
## Propuesta
Se expondrán las carencias de los sistemas de detección actuales en entornos dinámicos. Se propone como solución una arquitectura basada en principios Zero Trust y Security as Code que supere estas limitaciones.
# Análisis del problema
## Especificación de Requisitos
Se definen las necesidades funcionales: tráfico a bloquear
Se definen las necesidades no funcionales: despliegue automatizado de ambos entornos
# Diseño de la solución
## Arquitectura del Sistema
Diagrama de alto nivel de los dos escenarios a comparar: Escenario A (Seguridad en el borde) y Escenario B (Micro-segmentación y sensores de seguridad).
## Diseño Detallado
Definición de topología, tablas de enrutamiento y políticas de comunicación entre miscroservicios.
## Tecnología Utilizada
Justificación del stack tecnológico: Docker (infraestructura), Wazuh (SIEM/IDS), Suricata (Sonda de red) y Python/Bash (Scripting de ataque y respuesta).
# Desarrollo de la solución propuesta
En este capítulo se documentará la codificación de la infraestructura (Infrastructure as Code). Se detallará la creación de los archivos docker-compose.yml, la configuración de reglas personalizadas en el SIEM y el desarrollo de los scripts de automatización para el despliegue de ambos escenarios.
# Implantación
Descripción de la puesta en marcha del laboratorio. Se explicará cómo se lleva el diseño teórico a un entorno de ejecución real, los problemas de integración encontrados durante el despliegue de los contenedores y las soluciones adoptadas.
# Pruebas
Es el núcleo del análisis, se ejecutarán pruebas idénticas en ambos escenarios para  medir la eficacia.
Se documentarán los resultados obtenidos.
# Conclusiones
Discusión de los resultados obtenidos en las pruebas, esperando confirmar la eficacia del modelo Zero Trust para reducir el impacto de los ataques.
