---
name: anonimato-digital
description: Audita exposición de IP, DNS, WebRTC y ubicación en navegadores y clientes de IA sobre Windows y WSL2. Investiga discrepancias, aplica ajustes solicitados con restauración y verifica su efecto por proceso y perfil. Distingue protección de red, identidad de cuenta y contenido compartido.
---

# Anonimato digital

Produce un diagnóstico reproducible de exposición de datos. Explica qué observa cada prueba, qué ajuste puede corregir un hallazgo y qué evidencia permite cerrar la comprobación. No prometas anonimato ni conviertas una prueba parcial en un certificado del equipo.

## Delimitar el contexto

Identifica el dato a proteger, quién puede verlo y qué proceso origina la solicitud. Distingue navegador, CLI, servidor remoto e intermediario. Registra cliente, versión, perfil, sistema, destino y estado de VPN/proxy.

Aprovecha la información disponible. Pregunta solo por datos que cambien la interpretación o por una interrupción todavía no autorizada. Empieza por lectura; un diagnóstico no autoriza desconectar la VPN, reiniciar WSL o desvincular cuentas.

Carga las guías pertinentes:

- [Pruebas de red](references/pruebas-de-red.md): IP, DNS, WebRTC, IPv6 y transiciones.
- [Windows y navegadores](references/guia-windows.md): inventario, políticas, permisos, servicios y sincronización.
- [WSL2](references/guia-wsl2.md): proceso emisor, modo de red, resolver y proxy.
- [Privacidad ante IA](references/privacidad-ia.md): ubicación, identidad, contenido y contexto adjunto.
- [Evidencia y cambios](references/evidencia-y-cambios.md): resultados, restauración y cierre.

## Obtener evidencia

Registra el resultado esperado antes de interpretar el observado. Describe qué datos reciben los verificadores externos. Usa el cliente y perfil solicitado. Atribuye las capturas al usuario y conserva la incertidumbre si no se identifica el cliente.

El recolector [audit-windows.ps1](scripts/audit-windows.ps1) es opcional: inventaría configuración sin cambiarla ni hacer consultas de red. Su JSON contiene metadatos del equipo; mantenlo fuera del repositorio público y revisa errores por sección. No comprueba políticas efectivas ni sesiones web.

Distingue:
1. **Configuración:** valor escrito, tipo, alcance y versión compatible.
2. **Comportamiento:** respuesta del cliente o prueba ejecutada.
3. **Recorrido:** evidencia de la ruta real del tráfico cuando sea necesaria.

Una consulta exitosa no demuestra su recorrido. Una captura del navegador integrado no comprueba Brave. Un proceso VPN activo no demuestra cobertura de todos los clientes. Tailscale activo no demuestra uso de un exit node.

## Diagnosticar

| Observación | Investigar |
| --- | --- |
| IP inesperada | Proceso, proxy, exclusiones y rutas; identificar la dirección antes de declarar fuga |
| DNS de otro proveedor | DNS seguro, NRPT, VPN, NextDNS y atribución del resolver |
| Cero resolvers | Finalización de la prueba; usar otro verificador sin declarar éxito |
| IPv6 sin respuesta | Error DNS, proxy, ruta o conectividad; no concluir bloqueo permanente |
| WebRTC sin candidatos | Ejecución y permisos; registrar ausencia observada sin afirmar API deshabilitada |
| Política sin efecto | Página de políticas, errores, precedencia, tipo, versión y reinicio requerido |
| Linux y Windows difieren | Binario real, servidor remoto, NAT/mirrored, DNS y proxy |
| Servicio reconoce usuario o región | Cuenta, permisos, accesos anteriores, contenido y contexto |

Un PTR, ASN o ciudad aporta atribución parcial. No basta para declarar que un tercero opera para la VPN, comparte centro de datos o que una advertencia es un falso positivo. Resuelve contradicciones entre inventario y pruebas.

## Corregir dentro del alcance

Explica el ajuste y su efecto para quien usa la interfaz; añade clave, archivo o parámetro para desarrolladores. Consulta documentación oficial vigente cuando dependa de versión.

Conserva existencia, tipo y valor anteriores; preserva configuración ajena. No apliques recetas generales para desactivar servicios, IPv6, actualizaciones o protección antimalware. No cambies región o idioma como sustituto de investigar ubicación.

Verifica una copia independiente sin conexión antes de desvincular OneDrive. Coordina reinicios o pruebas de pérdida de túnel que interrumpan trabajo. Respeta autorizaciones existentes sin pedirlas de nuevo.

## Verificar y entregar

Repite la prueba en el mismo cliente, perfil y condiciones. Comprueba llamadas tras cambios WebRTC, resolución y acceso al servicio tras cambios DNS, y funciones afectadas tras cambios Windows. Ante una regresión, restaura y verifica recuperación.

Clasifica cada fila: **verificada en el contexto probado**, **discrepancia**, **inconclusa** o **no ejecutada**. WebRTC sin candidatos puede estar verificado como observación; un error de prueba no puede aprobarse.

Entrega contexto, observación, interpretación, cambio, evidencia posterior y pendientes. Separa ajustes propuestos de aplicados. No publiques IP, cuentas, capturas, redes, cookies, credenciales ni registros personales como ejemplos. No asignes porcentajes de anonimato. Limita las conclusiones a los clientes, escenarios y vías evaluados.
