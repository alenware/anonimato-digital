# Evidencia, cambios y restauración

## Ficha de prueba

Registra fecha con zona horaria, origen (herramienta o captura del usuario), sistema, aplicación y versión, perfil, destino, VPN/proxy, resultado esperado, observación y límites. Usa etiquetas locales para comparar direcciones sin publicar valores.

| Estado | Uso |
| --- | --- |
| Verificada en el contexto probado | La prueba ejecutada respalda la afirmación concreta |
| Discrepancia | Lo observado difiere de lo esperado; la causa puede seguir pendiente |
| Inconclusa | Timeout, proveedor sin atribuir, contexto ambiguo o evidencia insuficiente |
| No ejecutada | No se realizó |

«Verificada» califica una afirmación, no la seguridad del equipo. Separa configuración compatible, política efectiva, comportamiento y recorrido.

## Registro por operación

Conserva localmente:

- Aplicación/perfil o ruta/clave, versión y privilegios requeridos.
- Existencia previa, tipo y valor original; para archivos, copia y codificación.
- Cambio, causa que pretende resolver y funciones afectadas.
- Método exacto de restauración y prueba de recuperación.
- Resultado, errores y evidencia posterior.

Para un valor de registro inexistente, revertir significa quitar el valor creado. Si existía, restaura tipo y contenido originales. Para servicios, registra inicio y estado; no restaures todos como Automatic ni inicies uno antes detenido sin una razón documentada.

Preserva claves ajenas en archivos. No edites Preferences de un navegador activo: puede sobrescribirlas. Prefiere interfaz o política soportada. Comprueba aceptación de políticas y coordina reinicios necesarios.

## Pruebas posteriores

| Cambio | Privacidad | Función |
| --- | --- | --- |
| DNS / proxy | Detección y atribución desde el cliente | Resolver y acceder al servicio |
| WebRTC | Candidatos con los mismos permisos | Llamada autorizada |
| VPN / exclusiones | Salida y familias IP por cliente | Recursos necesarios |
| Ubicación | Permiso efectivo del sitio/app | Función dependiente, si se usa |
| Servicio / inicio | Estado tras el evento relevante | Búsqueda, notificaciones o autenticación |
| Sincronización | Estado y carpetas incluidas | Copia independiente sin conexión |

Si falla, restaura y verifica recuperación antes de otra hipótesis. Los cambios no probados permanecen pendientes.

## Informe

```text
Contexto: fecha, sistema, cliente/perfil, destino, VPN/proxy.
Objetivo: dato y observador.
Hallazgo: observación y fuente.
Interpretación: qué demuestra y qué no.
Acción: propuesta / aplicada / restaurada; valor previo.
Verificación: resultado posterior y función afectada.
Estado: verificada / discrepancia / inconclusa / no ejecutada.
Pendientes: evidencia o acceso necesario.
```

No incluyas informes del usuario en commits. Revisa capturas, JSON y respaldos: pueden contener identificadores sin contener contraseñas.
