# Ubicación e identidad ante servicios de IA

Una VPN cambia la salida de las conexiones cubiertas. El servicio sigue recibiendo contenido y puede asociarlo con una cuenta. Evalúa estos canales por separado.

| Canal | Qué revisar | Límite |
| --- | --- | --- |
| IP actual | Salida del proceso que llama al proveedor, incluido backend remoto o proxy | Otra aplicación no acredita esa conexión |
| Cuenta e historial | Sesiones, datos de facturación aportados y accesos anteriores disponibles | Una ubicación histórica no demuestra ubicación actual |
| Permisos | Ubicación en sistema, aplicación y sitio del perfil | Denegar ubicación no impide estimar región por IP o contenido |
| Contexto del cliente | Zona horaria, rutas, repositorio e instrucciones adjuntas | El contexto visible no revela todos los registros del proveedor |
| Mensajes y adjuntos | Direcciones, EXIF, comentarios, autor, hojas ocultas y contenido visual | Quitar metadatos no elimina información visible |
| Conectores | Datos que una integración autorizada consulta o incorpora | Disponible no significa que haya enviado todos los datos |
| Cookies y huella | Sesión, perfil, extensiones y señales del navegador | Relacionan actividad; no equivalen a coordenadas precisas |

## Flujo

1. Identifica proveedor, producto y modalidad: web, aplicación, API o intermediario.
2. Separa ubicación aproximada, ubicación precisa e identidad de cuenta.
3. Revisa permisos y contexto con el mínimo acceso necesario. No abras correo, historial completo, credenciales o archivos ajenos al alcance.
4. Examina una copia del adjunto previsto. No lo subas a un verificador para inspeccionarlo.
5. Propón revocar permisos específicos, reducir contexto o preparar una copia según el hallazgo.
6. Verifica interfaz, copia y siguiente solicitud observable. Mantén como desconocido lo que el proveedor no exponga.

Un perfil separado ayuda a separar cookies. Iniciar sesión en la misma cuenta permite asociar actividad. Cambiar idioma o zona horaria no acredita residencia en otro país. No recomiendes combinaciones arbitrarias de extensiones como garantía contra fingerprinting.

Distingue recopilación, entrenamiento y retención. Desactivar entrenamiento no significa que no se procese o conserve información. Consulta la política vigente del producto sin extrapolar consumo a API empresarial.

## Fuentes

- [OpenAI](https://openai.com/policies/privacy-policy/): cuenta, contenido, datos técnicos y ubicación.
- [Anthropic](https://privacy.claude.com/en/articles/11186740-does-claude-use-my-location): inferencia aproximada mediante IP y otras señales.
- [Controles de datos de ChatGPT](https://help.openai.com/en/articles/7039943).
