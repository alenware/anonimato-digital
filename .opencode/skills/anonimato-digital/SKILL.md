---
name: anonimato-digital
description: Audita la exposición de IP, ubicación, telemetría, sesiones y archivos sincronizados en Windows y WSL2. Úsala para reducir los datos que compartes con servicios web y asistentes de IA, o para revisar afirmaciones de anonimato.
---

# Privacidad y anonimato digital

## Diagnóstico

1. Parte del dato que el usuario quiere proteger y de quién quiere protegerlo. Distingue entre el sitio visitado, el proveedor de VPN, el proveedor de IA y las personas con acceso al equipo. Si el objetivo es general, empieza por la IP pública, los permisos, la cuenta y lo que se sube al servicio.
2. Identifica el sistema, navegador, perfil y aplicación que intervienen. En WSL2, identifica en qué sistema se ejecuta el proceso que abre la conexión. Un resultado en el navegador solo cubre ese perfil y esa conexión. Distingue la telemetría del sistema, los datos que recibe una web y los rastros guardados en el equipo.
3. Empieza con comprobaciones de solo lectura. Prioriza los controles de la interfaz y propón cambios concretos que se puedan deshacer. Registra el ajuste anterior y explica cómo restaurarlo. Para OneDrive, verifica el alcance de la sincronización y la disponibilidad de una copia independiente antes de desvincular.
4. Comprueba el resultado en la misma aplicación y perfil. Indica qué observaste, qué sigue siendo inferencia y qué queda por comprobar. Si un verificador externo es necesario, explica que recibirá datos de la conexión. Resume los resultados sin incluir valores de IP, nombres de cuenta, rutas personales ni nombres de redes cuando baste con indicar el estado.

## Cómo interpretar los hallazgos

- Una IP de salida distinta describe el tráfico observado. La cuenta, los permisos de ubicación y el contenido enviado se evalúan por separado.
- Un valor del registro o de un archivo de preferencias acredita una configuración escrita. Confirma su aplicación en la interfaz o en el comportamiento, especialmente si hay políticas administradas.
- Al revisar una guía o un informe, comprueba que cada conclusión corresponda a la prueba realizada. Un porcentaje de anonimato, una etiqueta de IP o una sola prueba de WebRTC no permiten extrapolar a otros sitios, perfiles ni aplicaciones.

- Lee [la guía para Windows](references/guia-windows.md) para revisar Windows, navegadores, OneDrive o los controles de datos de ChatGPT.
- Lee [la guía para WSL2](references/guia-wsl2.md) para revisar OpenCode u otro cliente de Linux, su salida por VPN o proxy y su acceso a archivos de Windows.
