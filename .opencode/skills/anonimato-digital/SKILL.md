---
name: anonimato-digital
description: Audita la exposición de IP, DNS, WebRTC, ubicación, sesiones y archivos en Windows y WSL2. Úsala para diagnosticar fugas en navegadores o clientes de IA, aplicar ajustes de privacidad y verificar su efecto en el proceso y perfil afectados.
---

# Anonimato digital

Investiga la exposición de datos en el entorno indicado por el usuario. Relaciona cada hallazgo con una observación reproducible, aplica los ajustes solicitados y verifica tanto el resultado de privacidad como las funciones afectadas.

## Seleccionar el contexto

Identifica el dato que se quiere proteger, quién puede observarlo y la aplicación implicada. Determina si la petición sale de un navegador, una CLI, un servidor de OpenCode o un intermediario del proveedor. Registra sistema, perfil, destino y estado de la VPN.

En WSL2, localiza el lanzador y el binario que ejecuta. Comprueba si el servidor de la aplicación corre en Linux, Windows o un sistema remoto. Una prueba debe ejecutarse en el entorno que origina la conexión.

Carga las referencias según el caso.

- Para IP pública, DNS o WebRTC del navegador, sigue [pruebas-de-red.md](references/pruebas-de-red.md).
- Para permisos, diagnóstico de Windows, OneDrive y controles de cuenta, sigue [guia-windows.md](references/guia-windows.md).
- Para procesos Linux, NAT, mirrored, DNS y proxy en WSL2, sigue [guia-wsl2.md](references/guia-wsl2.md).

## Obtener una línea base

Antes de modificar ajustes, registra los valores relevantes y el resultado esperado. Reutiliza la información disponible sobre la VPN o proxy para identificar su salida. Describe qué datos recibe cualquier verificador externo que vayas a utilizar.

Ejecuta únicamente las pruebas que respondan a la solicitud. En el navegador, comprueba que la página haya ejecutado JavaScript y completado la detección. Una consulta HTTP desde una herramienta remota observa la conexión de esa herramienta. Usa el navegador y perfil indicados para medir su exposición.

Registra por separado IPv4, IPv6, resolvers DNS y candidatos de WebRTC. Anota pruebas sin respuesta como inconclusas. Enmascara IP, cuentas, nombres de redes y rutas personales cuando el valor completo resulte innecesario. Inspecciona campos concretos de configuración y mantén credenciales, cookies y valores secretos de proxy fuera del informe.

## Investigar los hallazgos

| Observación | Siguiente comprobación |
| --- | --- |
| IP directa pese a tener la VPN conectada | Estado de la VPN, exclusiones por aplicación o destino y ruta del proceso que originó la solicitud. |
| IPv4 coincide y IPv6 presenta una salida inesperada | Cobertura IPv6 de la VPN y rutas del cliente. Identifica la dirección antes de atribuirla a la conexión directa. |
| Resolver DNS inesperado | DNS seguro del navegador, configuración del cliente VPN y resolver de la aplicación. En WSL2, revisa el mecanismo de resolución del proceso. |
| WebRTC presenta una IP pública adicional | Origen del candidato, política de manejo de IP y reglas de VPN o proxy aplicables a ese tráfico. Registra direcciones privadas y nombres mDNS por separado. |
| Windows y WSL2 producen resultados distintos | Proceso real, modo de red, variables de proxy, exclusiones y destino de ambas pruebas. |
| Una web obtiene ubicación o reconoce una cuenta | Permisos efectivos del sitio, sesión activa, sincronización y contenido compartido. |
| Un archivo parece local pero depende de OneDrive | Disponibilidad sin conexión y existencia de una copia independiente de la carpeta sincronizada. |

Formula la hipótesis que conecta el hallazgo con el ajuste propuesto. Si la prueba queda pendiente, bloqueada o sin datos suficientes, resuelve esa limitación antes de concluir que existe una fuga. Una diferencia entre resolvers requiere investigar su configuración y ruta. Una etiqueta de VPN o una ciudad estimada solo aporta contexto sobre la clasificación del sitio.

## Aplicar ajustes

Actúa dentro del alcance solicitado y de la autorización existente. Explica el efecto concreto del cambio con lenguaje adecuado al usuario. Para personas que usan la interfaz, indica el control y su efecto. Para desarrolladores, incluye el archivo, parámetro o proceso pertinente.

Prioriza ajustes soportados por la aplicación y comprueba su compatibilidad con la versión instalada. Conserva el valor anterior y una forma de restaurarlo. Aplica un cambio por vez cuando permita atribuir el resultado a una causa.

Al editar configuraciones, preserva claves ajenas al hallazgo. Comprueba también el valor efectivo en la interfaz o en el comportamiento del cliente. Una escritura exitosa solo acredita la modificación del archivo o registro.

Antes de desvincular OneDrive, comprueba que la copia independiente sea accesible sin conexión. Para cambios de WSL, identifica el alcance de `.wslconfig` y `/etc/wsl.conf`. Si hace falta `wsl --shutdown`, informa de la interrupción de las distribuciones activas y coordina el reinicio con el trabajo en curso.

## Verificar y cerrar

Repite la prueba con el mismo cliente, perfil, destino y estado de la VPN. En páginas que puedan conservar direcciones anteriores, inicia una nueva detección desde una pestaña nueva. Registra cualquier variación de condiciones que limite la comparación.

Comprueba las funciones que el ajuste pueda afectar. Después de modificar WebRTC, prueba una llamada habitual. Después de modificar DNS o proxy, prueba la resolución y la conexión del cliente solicitado. Evalúa caídas y reconexiones de VPN cuando ese comportamiento forme parte del objetivo y la interrupción esté autorizada.

Si el cambio falla o provoca una regresión, restaura el valor anterior y comprueba la recuperación antes de probar otra hipótesis. Conserva como pendiente cualquier prueba que no puedas ejecutar.

Entrega un informe breve con el contexto, cada hallazgo, el cambio aplicado, la evidencia posterior y la forma de revertirlo. Distingue resultados verificados, discrepancias e inconclusos. Atribuye cada conclusión al contexto probado y explica lo que queda pendiente para cumplir el objetivo.
