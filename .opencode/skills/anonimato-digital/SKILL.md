---
name: anonimato-digital
description: Audita y reduce la exposición de datos de navegadores, clientes de IA y procesos CLI en Windows y WSL2. Revisa la salida IPv4/IPv6, VPN, DNS, proxies, WebRTC, permisos de ubicación, telemetría, sesiones y OneDrive. Identifica el proceso que abre la conexión, aplica ajustes específicos cuando se solicitan y verifica su efecto en el mismo cliente.
---

# Privacidad y anonimato digital

Skill de OpenCode para desarrolladores que necesitan saber **qué datos expone un cliente y desde qué entorno los envía**. Audita Windows, navegadores Chromium y procesos Linux en WSL2. Distingue entre el navegador, la CLI y el servidor que ejecuta las solicitudes al proveedor de IA.

## Qué inspecciona y qué cambios aplica

La ejecución comienza con un diagnóstico de solo lectura. Si el usuario pide aplicar cambios, usa los controles de la aplicación o del sistema para ajustar los valores que afectan al caso.

| Componente | Diagnóstico | Cambios que puede aplicar |
| --- | --- | --- |
| Windows | Permisos de ubicación del sistema y las apps, datos de diagnóstico opcionales y sincronización del portapapeles. | Revocar permisos de ubicación concretos y desactivar el diagnóstico opcional o la sincronización del portapapeles si están activos. |
| Brave, Chrome y Edge | Permisos y sesiones por perfil, sincronización de cuenta, extensiones y exposición de direcciones por WebRTC. | Revocar permisos de sitio, crear un perfil separado y ajustar sincronización o protecciones de rastreo. Si se ajusta WebRTC, verificar también una llamada. |
| WSL2 y red | Binario Linux o lanzador de Windows, servidor que hace la petición, modo NAT o mirrored, rutas IPv4/IPv6, variables de proxy y resolución DNS. | Corregir el proxy del cliente o las reglas del túnel dividido. Si el diagnóstico apunta a WSL2, evaluar `autoProxy`, `dnsTunneling` y `networkingMode` según la versión de Windows y la VPN. |
| OneDrive y archivos | Carpetas sincronizadas, archivos disponibles sin conexión y datos incluidos en los adjuntos. | Desvincular OneDrive tras comprobar una copia independiente fuera de la carpeta sincronizada. Preparar una copia que contenga solo los datos necesarios para enviar. |
| Cuenta del servicio de IA | Cuenta activa, configuración de uso para entrenamiento y políticas de retención. | Ajustar los controles de datos disponibles para esa cuenta. Verificar por separado qué política de retención se aplica. |

## Flujo de diagnóstico y verificación

1. Identifica qué dato se quiere proteger y frente a quién. Distingue el sitio visitado, el proveedor de VPN, el proveedor de IA y las personas con acceso al equipo.
2. Localiza el proceso que abre la conexión. En WSL2, `command -v opencode` y `wslinfo --networking-mode` orientan el diagnóstico. Contrasta las rutas y la configuración de proxy con la salida observada desde el proceso relevante. Una prueba con `curl` acredita la salida de ese comando hacia ese destino.
3. Antes de modificar un ajuste, registra su valor anterior y el alcance del cambio. `.wslconfig` abarca todas las distribuciones WSL2 del usuario. `/etc/wsl.conf` corresponde a una distribución. Si el cambio requiere `wsl --shutdown`, indica la interrupción de las distribuciones activas y cómo restaurar el valor anterior.
4. Repite la comprobación después del cambio en el mismo cliente y perfil. Si necesitas un verificador externo, indica que recibirá datos de la conexión. Registra el ajuste anterior, el aplicado, la prueba, el resultado y lo que queda por comprobar. Omite direcciones IP, cuentas, rutas personales y valores de proxy cuando baste con indicar el estado.

## Cómo interpretar los hallazgos

- Una IP de salida distinta describe el tráfico observado. La cuenta, los permisos de ubicación y el contenido enviado se evalúan por separado.
- Un valor del registro o de un archivo de preferencias acredita una configuración escrita. Confirma su aplicación en la interfaz o en el comportamiento, especialmente si hay políticas administradas.
- Al revisar una guía o un informe, comprueba que cada conclusión corresponda a la prueba realizada. Un porcentaje de anonimato, una etiqueta de IP o una sola prueba de WebRTC no permiten extrapolar a otros sitios, perfiles ni aplicaciones.

## Guías operativas

- Lee [la guía para Windows](references/guia-windows.md) para revisar Windows, navegadores, OneDrive o los controles de datos de ChatGPT.
- Lee [la guía para WSL2](references/guia-wsl2.md) para revisar OpenCode u otro cliente de Linux, su salida por VPN o proxy y su acceso a archivos de Windows.
