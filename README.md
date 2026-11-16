# Anonimato digital

Skill de OpenCode para auditar la exposición de datos en Windows y WSL2 y aplicar ajustes de privacidad verificables. Revisa qué dirección IP presenta una conexión, qué servidores resuelven sus consultas DNS y qué información adicional expone el navegador mediante WebRTC, permisos, sesiones y archivos compartidos.

El flujo sirve tanto para revisar un navegador personal como para diagnosticar una CLI o un cliente de IA. Cada hallazgo se vincula al proceso, perfil y destino probados. Los cambios se acompañan de una comprobación posterior y un procedimiento para restaurar el ajuste anterior.

## Alcance

| Área | Qué se comprueba | Ajustes posibles |
| --- | --- | --- |
| Red | Salida IPv4/IPv6, reglas de VPN, proxy y resolvers DNS. | Corregir exclusiones del túnel dividido, proxy del cliente o selección de DNS. |
| Navegador | Direcciones expuestas por WebRTC, permisos de ubicación, sesiones y sincronización del perfil. | Ajustar la política de WebRTC, revocar permisos específicos y configurar un perfil independiente. |
| Windows | Diagnóstico opcional, ubicación y portapapeles sincronizado. | Desactivar la recopilación opcional o la sincronización solicitada y verificar el estado efectivo. |
| WSL2 | Ejecutable invocado, proceso que abre la conexión, modo NAT o mirrored y configuración de DNS y proxy. | Ajustar la configuración del cliente o evaluar cambios concretos en WSL según el problema observado. |
| Archivos y cuentas | Carpetas de OneDrive, disponibilidad local de archivos, contenido y metadatos de adjuntos, controles de datos del servicio de IA. | Desvincular la sincronización tras verificar una copia independiente, preparar adjuntos y ajustar controles de datos. |

La skill contiene instrucciones y guías que OpenCode interpreta con las herramientas disponibles en cada entorno. La aplicación de ajustes depende del acceso al sistema y del alcance solicitado. Las pruebas externas reciben la IP de la conexión que las consulta.

## Instalación

Necesitas OpenCode y acceso al navegador o entorno que quieras revisar. Para usar la skill desde este repositorio, ejecuta los siguientes comandos en PowerShell o en una terminal Linux.

```sh
git clone https://github.com/alenware/anonimato-digital.git
cd anonimato-digital
opencode
```

OpenCode descubre la skill en `.opencode/skills/anonimato-digital/SKILL.md`. Para incorporarla a otro proyecto, copia la carpeta completa `anonimato-digital`, incluido `references/`, dentro de su directorio `.opencode/skills/`. [Descubrimiento de skills](https://opencode.ai/docs/skills/)

En WSL2, ejecuta OpenCode para Linux desde la distribución que quieras diagnosticar. Comprueba con `command -v opencode` qué lanzador resuelve la terminal y verifica el binario al que apunta. Un lanzador ubicado en una unidad de Windows puede ejecutar la versión de Windows.

## Uso

Para revisar un navegador con la VPN conectada, puedes escribir este mensaje.

```text
Usa @anonimato-digital para comprobar la IP pública, el DNS y WebRTC
de mi perfil habitual de Chrome con la VPN conectada.
Explícame qué muestra cada prueba y qué ajuste corresponde a cada hallazgo.
```

Para diagnosticar un cliente de IA en WSL2, identifica la aplicación y la salida esperada.

```text
Usa @anonimato-digital para revisar la conexión de OpenCode desde WSL2.
Comprueba qué proceso hace las peticiones y cómo usa la VPN y el proxy.
Aplica las correcciones necesarias y verifica el resultado en ese cliente.
```

## Cómo trabaja

1. Define el cliente, perfil, destino y resultado esperado.
2. Registra la configuración actual y ejecuta las pruebas relevantes.
3. Investiga las discrepancias y localiza el ajuste que puede explicarlas.
4. Aplica los cambios solicitados, conservando los valores anteriores.
5. Repite las pruebas en las mismas condiciones y comprueba las funciones afectadas.
6. Entrega los hallazgos, cambios, evidencias y comprobaciones pendientes.

Las pruebas de navegador usan IPLeak para IP pública y DNS, y BrowserLeaks para WebRTC. La guía explica qué campos mirar y cómo interpretar una dirección inesperada, una prueba incompleta o un resultado distinto entre Windows y WSL2. [Procedimiento de pruebas](.opencode/skills/anonimato-digital/references/pruebas-de-red.md)

## Resultado de una revisión

| Hallazgo | Cambio aplicado | Verificación | Estado |
| --- | --- | --- | --- |
| El navegador presenta la IP directa pese a tener la VPN conectada. | Se retira una exclusión del túnel dividido. | La prueba del mismo perfil muestra la salida esperada. | Corregido en el contexto probado. |
| La prueba de IPv6 termina sin respuesta. | Pendiente de diagnóstico de conectividad. | La prueba carece de una respuesta válida. | Inconcluso. |

Esta tabla ilustra el formato del informe. Las evidencias se redactan con el mínimo de datos identificables necesario. Cada resultado conserva su contexto y sus límites de observación. La asociación con una cuenta, el contenido enviado y la retención del proveedor se evalúan además de la salida de red.

## Referencias

- [Instrucciones para el agente](.opencode/skills/anonimato-digital/SKILL.md)
- [Pruebas de IP, DNS y WebRTC](.opencode/skills/anonimato-digital/references/pruebas-de-red.md)
- [Configuración de Windows](.opencode/skills/anonimato-digital/references/guia-windows.md)
- [Diagnóstico de WSL2](.opencode/skills/anonimato-digital/references/guia-wsl2.md)
