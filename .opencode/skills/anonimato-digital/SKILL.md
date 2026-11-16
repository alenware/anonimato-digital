---
name: anonimato-digital
description: Audita y reduce la exposición de datos de navegadores, clientes de IA y procesos CLI en Windows y WSL2. Revisa la salida IPv4/IPv6, VPN, DNS, proxies, WebRTC, permisos de ubicación, telemetría, sesiones y OneDrive. Identifica el proceso que abre la conexión, aplica ajustes específicos cuando se solicitan y verifica su efecto en el mismo cliente.
---

# Privacidad y anonimato digital

Skill de OpenCode para comprobar qué datos ven las webs y los servicios de IA cuando usas Windows o WSL2. Sirve para revisar tu navegador paso a paso o diagnosticar un cliente de IA que se ejecuta desde una terminal.

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

1. **Elige qué vas a comprobar.** Por ejemplo, si Brave muestra la IP de salida de la VPN o si un sitio conserva permiso para usar tu ubicación. Anota el navegador y perfil, o el cliente y servidor de IA, y qué resultado esperas.
2. **Toma una línea base con la configuración actual.** Anota si la VPN está conectada, qué salida esperas y qué ajuste está activo. Para un navegador, sigue las pruebas de [IP pública, DNS y WebRTC](references/pruebas-de-red.md). Las páginas de prueba reciben la IP desde la que las visitas. Para WSL2, identifica primero el binario y el proceso que hace la petición con la [guía de WSL2](references/guia-wsl2.md). Una prueba con `curl` mide la salida de ese comando hacia ese destino.
3. **Usa el resultado para elegir el siguiente ajuste.** Si aparece la IP del proveedor de Internet, revisa si el navegador o cliente está excluido del túnel. Si aparece un DNS inesperado, revisa el DNS seguro del navegador y el que configura la VPN. Si solo WebRTC muestra una IP pública adicional, comprueba la política del perfil y los candidatos de conexión.
4. **Cambia un ajuste y conserva el valor anterior.** Cuando se pida aplicarlo, usa el control del navegador, del sistema o de la VPN. En WSL2, `.wslconfig` abarca todas las distribuciones del usuario y `/etc/wsl.conf` corresponde a una sola. Si el cambio requiere `wsl --shutdown`, indica qué se interrumpe y cómo revertirlo.
5. **Repite la misma prueba.** Usa el mismo navegador, perfil, página y estado de la VPN. Si cambiaste WebRTC, verifica también que funcione una llamada habitual. Si el resultado sigue siendo inesperado, conserva la evidencia antes de probar otro ajuste.
6. **Entrega el resultado con su alcance.** Para cada prueba deja el resultado esperado, el observado, el ajuste aplicado y la comprobación posterior. Usa estados como «coincide», «hay una discrepancia» o «sin datos suficientes». Evita incluir IP completas, cuentas, rutas personales o valores de proxy.

## Cómo interpretar los hallazgos

- Una IP de salida distinta describe el tráfico observado. La cuenta, los permisos de ubicación y el contenido enviado se evalúan por separado.
- Un valor del registro o de un archivo de preferencias acredita una configuración escrita. Confirma su aplicación en la interfaz o en el comportamiento, especialmente si hay políticas administradas.
- Al revisar una guía o un informe, comprueba que cada conclusión corresponda a la prueba realizada. Un porcentaje de anonimato, una etiqueta de IP o una sola prueba de WebRTC no permiten extrapolar a otros sitios, perfiles ni aplicaciones.

## Guías operativas

- Lee [la guía para Windows](references/guia-windows.md) para revisar Windows, navegadores, OneDrive o los controles de datos de ChatGPT.
- Lee [la guía para WSL2](references/guia-wsl2.md) para revisar OpenCode u otro cliente de Linux, su salida por VPN o proxy y su acceso a archivos de Windows.
