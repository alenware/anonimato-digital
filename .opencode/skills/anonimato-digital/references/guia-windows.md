# Guía de privacidad para Windows y servicios de IA

Revisa los permisos, la conexión y los datos compartidos desde el perfil y la aplicación que utilizas. Registra la configuración inicial y comprueba el efecto de cada ajuste en ese mismo contexto.

## 1. Ubicación e IP pública

- **Windows.** En Windows 11 abre **Configuración → Privacidad y seguridad → Ubicación**. En Windows 10 abre **Configuración → Privacidad → Ubicación**. Revisa qué apps usan la ubicación del sistema. Las apps de escritorio pueden tener controles distintos y algunos servicios pueden estimar una zona a partir de la IP. [Servicio de ubicación de Windows](https://support.microsoft.com/en-us/windows/privacy/windows-location-service-and-privacy)
- **Navegador.** Busca **Ubicación** en la configuración de Brave, Chrome o Edge. Revisa los sitios que ya tienen permiso y retíralo donde sobre. Comprueba el permiso en el perfil que usas. [Permisos de Chrome](https://support.google.com/chrome/answer/142065) · [Ubicación en Edge](https://support.microsoft.com/en-us/edge/location-and-privacy-in-microsoft-edge)
- **VPN.** Si ya usas una, revisa que el navegador o la app estén incluidos en el túnel. Consulta qué hace el *kill switch* de tu cliente al perder la conexión, al desconectarte manualmente y cuando hay aplicaciones excluidas. [Kill switch de Proton VPN](https://protonvpn.com/support/what-is-kill-switch) · [Túnel dividido](https://protonvpn.com/support/protonvpn-split-tunneling)

**Cómo comprobarlo.** Desde el perfil que te interesa, consulta la IP pública en el verificador de tu VPN o en otro servicio que aceptes consultar. Ese servicio verá la IP de la conexión. Revisa IPv4 e IPv6 si la prueba ofrece ambas y registra solo si la salida esperada coincide con la observada. Un resultado en Chrome deja pendiente la misma comprobación en Edge, el cliente de escritorio o cualquier otra app.

WebRTC se usa en llamadas y otras conexiones en tiempo real. Si necesitas comprobarlo, revisa las direcciones que muestra una prueba WebRTC en ese perfil. Una dirección privada puede pertenecer a la red local y una dirección pública inesperada requiere investigar la ruta. Si cambias la política de WebRTC, prueba una llamada que uses habitualmente. [IETF RFC 8828](https://www.rfc-editor.org/rfc/rfc8828.html)

## 2. Navegador, cuenta y contenido

- Usa un perfil independiente si quieres separar cookies y sesiones. Comprueba qué cuentas están abiertas y si habilitaste la sincronización en ese perfil. Si inicias sesión en el mismo servicio, este puede asociar la actividad con esa cuenta. [Perfiles de Chrome](https://support.google.com/chrome/answer/2364824) · [Política de privacidad de OpenAI](https://openai.com/policies/privacy-policy/)
- En Brave, los controles de Shields permiten revisar el bloqueo de rastreadores y las protecciones contra la huella del navegador. En cada navegador, revisa también los permisos por sitio y las extensiones del perfil. Desactiva un permiso o una extensión a la vez para poder identificar qué cambió. [Brave Shields](https://brave.com/shields/) · [Permisos por sitio en Chrome](https://support.google.com/chrome/answer/114662)
- Antes de compartir un archivo con un asistente de IA, abre la copia que vas a enviar. Revisa el contenido visible, el nombre del archivo y, cuando aplique, autor, comentarios, hojas ocultas o metadatos de ubicación. Comparte el fragmento necesario. En ChatGPT, revisa **Configuración → Controles de datos** para elegir si tus conversaciones ayudan a mejorar los modelos. La política de retención se consulta por separado. [Controles de datos de ChatGPT](https://help.openai.com/en/articles/7039943) · [Retención de chats y archivos](https://help.openai.com/en/articles/8983778-chat-and-file-retention-policies-in-chatgpt)

## 3. Diagnóstico y sincronización en Windows

- En **Configuración**, busca **Diagnóstico y comentarios** y revisa si está activo el envío de datos de diagnóstico opcionales. Anota la edición de Windows y vuelve a revisar la pantalla después de cambiar el ajuste. La opción de apagar los datos de diagnóstico depende de la edición. [Niveles de diagnóstico de Windows](https://learn.microsoft.com/en-us/windows/privacy/configure-windows-diagnostic-data-in-your-organization)
- Si quieres que el portapapeles se quede en el equipo, revisa su sincronización entre dispositivos en **Configuración → Sistema → Portapapeles**. Desactiva la sincronización si está habilitada y esa función te sobra. [Portapapeles en Windows](https://support.microsoft.com/en-us/windows/apps/using-the-clipboard)
- Si quieres desvincular OneDrive, identifica primero qué carpetas sincroniza. Descarga los archivos que solo estén en línea, copia lo que necesites a una ubicación fuera de la carpeta sincronizada y verifica que se puedan abrir sin conexión. Después, en OneDrive, abre **Configuración → Cuenta → Desvincular este equipo**. Comprueba que la carpeta independiente sigue accesible. Desvincular el equipo deja los archivos de la nube en su lugar. [Archivos a petición](https://support.microsoft.com/en-us/onedrive/save-disk-space-with-onedrive-files-on-demand-for-windows) · [Detener la sincronización](https://support.microsoft.com/en-us/onedrive/how-to-cancel-or-stop-sync-in-onedrive)

## Interpretación de la configuración

| Ajuste o señal | Alcance de la comprobación |
| --- | --- |
| `AllowTelemetry` en el registro | Comprueba el nivel efectivo y su compatibilidad con la edición de Windows. [Niveles de diagnóstico](https://learn.microsoft.com/en-us/windows/privacy/configure-windows-diagnostic-data-in-your-organization) |
| Idioma, región y zona horaria | Describen preferencias regionales. El servicio también puede recibir IP, datos de cuenta y contenido enviado. [Política de privacidad de OpenAI](https://openai.com/policies/privacy-policy/) |
| Etiquetas de VPN y proxy | Reflejan la clasificación del verificador consultado. La prueba de salida requiere contrastar la dirección observada con la esperada. |
| Política de WebRTC | Puede modificar interfaces, rutas o transporte. Verifica las direcciones expuestas y el funcionamiento de las llamadas. [IETF RFC 8828](https://www.rfc-editor.org/rfc/rfc8828.html) |
| Servicios de Windows | Evalúa las dependencias antes de modificarlos. El indicador NCSI interviene en la detección de conectividad usada por aplicaciones y actualizaciones. [NCSI y conectividad](https://learn.microsoft.com/en-us/troubleshoot/windows-client/networking/internet-explorer-edge-open-connect-corporate-public-network) |

## Verificación y restauración

Para cada ajuste, anota el perfil o la aplicación, el valor anterior, el cambio, la prueba y el resultado observado. Si aparece un problema, restaura el valor anterior desde el mismo menú y repite la prueba. En OneDrive, revisa las carpetas y los cambios pendientes antes de volver a vincular la cuenta. [Volver a vincular OneDrive](https://support.microsoft.com/en-us/onedrive/unlink-and-re-link-onedrive)
