# Pruebas de IP, DNS y WebRTC

Haz las pruebas en el navegador y perfil que usas de verdad. Si quieres comprobar una VPN, conéctala y abre pestañas nuevas. Anota qué salida y qué DNS esperas según tu configuración. Basta con apuntar si coinciden. Las dos páginas reciben la IP desde la que las visitas y pueden ver otros datos técnicos durante la prueba.

## 1. IP pública con IPLeak

La IP pública es la dirección que ve una web cuando tu navegador se conecta. Abre [IPLeak](https://ipleak.net/) y busca **Your IP addresses**. Compara cada IPv4 o IPv6 pública que aparezca con la salida esperada de tu VPN o proxy.

- **Coincide** si las direcciones públicas mostradas corresponden a la salida esperada.
- **Discrepancia** si ves una IP que ya sabes que corresponde a tu conexión directa cuando esperabas la VPN. Revisa si el navegador está excluido del túnel, reconecta si hace falta y repite la prueba.
- **Sin datos suficientes** si no aparece una familia de IP que querías comprobar o no puedes identificar la salida. Para revisar IPv4 o IPv6 por separado, usa los enlaces **IPv4** y **IPv6** que ofrece IPLeak. Una etiqueta como «VPN» o «proxy» es un dato de clasificación del sitio.

## 2. DNS con IPLeak

DNS traduce nombres de sitios en direcciones. En la misma página, espera a que termine **DNS detection** y revisa quién respondió a las consultas de prueba.

- **Coincide** si solo aparecen proveedores previstos por tu VPN o por el DNS seguro del navegador.
- **Discrepancia** si aparece tu proveedor de Internet u otro resolver fuera de lo esperado. Revisa qué DNS configura la VPN y si el navegador selecciona su propio proveedor. En WSL2, revisa también `dnsTunneling` si el proceso usa el resolver del sistema. Cambia un ajuste y repite la prueba desde el mismo perfil.
- **Sin datos suficientes** si la prueba queda pendiente o el proveedor resulta desconocido. La lista muestra los resolvers que respondieron a la prueba. Para determinar si las consultas cruzaron el túnel necesitas comprobar también la ruta o el registro del cliente VPN.

## 3. WebRTC con BrowserLeaks

WebRTC se usa para llamadas en el navegador y puede revelar direcciones adicionales al preparar una conexión. Abre [BrowserLeaks · WebRTC Leak Test](https://browserleaks.com/webrtc) en una pestaña nueva del mismo perfil. Compara **Your Remote IP** con **Public IP Address** en **Your WebRTC IP**.

- **Coincide** si las IP públicas que muestra WebRTC corresponden a las salidas previstas. Una dirección privada o un nombre `.local` corresponde a un candidato local y se registra por separado.
- **Discrepancia** si WebRTC muestra la IP pública de tu conexión directa y la página muestra la salida de la VPN. Si aparece otra IP pública desconocida, identifica su origen antes de atribuirla a una fuga. Revisa las reglas del túnel o la política de manejo de IP de WebRTC en ese perfil. Si cambias la política, repite la prueba y haz una llamada de prueba con una aplicación que uses.
- **Sin datos suficientes** si la página no muestra candidatos públicos. Registra «sin candidatos públicos observados» y comprueba si la página pudo ejecutar JavaScript. Esta observación cubre la página, el perfil y los permisos en uso durante la prueba. [IETF RFC 8828](https://www.rfc-editor.org/rfc/rfc8828.html)

## Ejemplo de registro

| Prueba | Antes | Ajuste | Después |
| --- | --- | --- | --- |
| IP pública | El sitio muestra la IP de la conexión directa. | Se retiró la exclusión del navegador en el túnel dividido. | IPv4 coincide con la salida de la VPN. IPv6 queda por comprobar. |
| DNS | Aparece un proveedor inesperado. | Se ajustó el proveedor de DNS seguro del perfil. | La prueba muestra el resolver esperado. |
| WebRTC | Aparece la IP pública de la conexión directa. | Se limitó el uso de interfaces en la política de WebRTC del perfil. | La IP directa dejó de aparecer en esta prueba y la llamada habitual funcionó. |
