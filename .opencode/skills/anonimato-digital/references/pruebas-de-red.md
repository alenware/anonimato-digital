# Pruebas de IP, DNS, WebRTC e IPv6

Identifica cliente, perfil, versión, destino y estado de VPN. Anota la salida y resolvers esperados. Las páginas reciben tu IP y señales técnicas del navegador. Las capturas del usuario son evidencia aportada: registra su origen y no las atribuyas a otros clientes.

## IP pública

Abre [IPLeak](https://ipleak.net/) en el perfil solicitado y espera al resultado. Compara IPv4 e IPv6 por separado con la salida prevista. Una IP inesperada exige identificar su origen y revisar proxy, túnel dividido y proceso emisor.

La geolocalización de una IP es una estimación. No es una lectura de GPS ni prueba de la ubicación física del usuario. Una etiqueta de VPN indica clasificación del servicio.

## DNS: configuración, respuesta y recorrido

DNS traduce nombres en direcciones. Hay tres preguntas diferentes:

1. ¿Qué resolver está configurado?
2. ¿Qué infraestructura respondió a las consultas de prueba?
3. ¿Por dónde viajaron las consultas?

### Navegador

Usa la detección DNS de IPLeak o [BrowserLeaks DNS](https://browserleaks.com/dns). Espera a que termine; registra número, proveedores y resultado por navegador.

- Cero servidores: inconcluso, no «sin fugas». Contrasta con el segundo verificador.
- Varios servidores o cantidades distintas entre repeticiones: no bastan para demostrar fuga.
- Proveedor inesperado: revisa DNS seguro del navegador, VPN, NextDNS u otro servicio y atribución.
- IPs IPv6 en la lista: son direcciones observadas de resolvers. No demuestran conectividad IPv6 directa del PC.

Consulta solo los ajustes relevantes en el perfil. El DNS seguro del navegador puede usar un proveedor distinto del sistema. Registra si es una elección prevista y si su transporte está cubierto por la VPN.

### Windows

Consultas de lectura desde PowerShell:

```powershell
Get-DnsClientServerAddress |
    Where-Object { $_.ServerAddresses.Count -gt 0 } |
    Select-Object InterfaceAlias, AddressFamily, ServerAddresses
Get-DnsClientNrptPolicy -Effective
Resolve-DnsName example.com -Type A -DnsOnly -NoHostsFile
```

NRPT es la tabla de reglas que Windows utiliza para seleccionar resolución según el nombre. Una regla para `.` es relevante para el resolver del sistema; no prueba que toda aplicación use ese resolver.

Para contrastar un servidor concreto, utiliza `nslookup example.com DIRECCION_DEL_RESOLVER`, sustituyendo el último argumento por la dirección observada. Limita tiempo e intentos. No cambies los DNS para hacer esta prueba.

Una respuesta de Resolve-DnsName con `-Server` no basta para demostrar que el servidor indicado recibió paquetes: intervienen comportamiento del resolver y cachés. Contrasta con consulta directa y, si se necesita atribución del recorrido, evidencia de tráfico.

Un timeout contra un router solo acredita que esa consulta no obtuvo respuesta. No demuestra ausencia de paquetes emitidos ni bloqueo permanente.

### Atribución del proveedor

Registra el nombre publicado por el verificador y, si hace falta, PTR, ASN y documentación del operador. Un PTR con nombre de CDN no demuestra relación operativa con la VPN ni centro de datos compartido. Mantén la atribución pendiente hasta tener respaldo suficiente. No clasifiques una advertencia como falso positivo solo porque no coincide el nombre comercial.

### Recorrido del tráfico

Cuando haga falta cerrar esta cuestión, usa una herramienta de captura disponible y autorizada. Limita la captura a consultas de prueba, duración y interfaces necesarias; evita registrar tráfico ajeno.

- Genera nombres nuevos bajo un dominio de prueba controlado o un verificador aceptado para evitar respuestas solo de caché.
- Observa la interfaz física y la virtual de VPN. Documenta también interfaces omitidas.
- Busca DNS en claro por UDP/TCP 53 y tráfico al resolver esperado. DNS cifrado requiere revisar DoH/DoT y sus destinos; un filtro de puerto 53 no cubre DoH.
- Una consulta en claro por una interfaz física fuera del túnel contradice el objetivo de proteger ese DNS. Tráfico cifrado hacia el servidor VPN es compatible con el objetivo.
- Ausencia de paquetes solo es evidencia útil si el punto de captura funciona y la consulta realmente ocurrió.

No inspecciones contenido HTTPS ni instales certificados para esta comprobación. Si no se captura tráfico, indica «recorrido no verificado».

## WebRTC

Abre [BrowserLeaks WebRTC](https://browserleaks.com/webrtc) y compara IP remota con candidatos locales y públicos. Contrasta con la sección WebRTC de IPLeak si es necesario.

- IP pública directa inesperada: investigar ruta y política.
- Dirección privada o nombre mDNS: registrar por separado; no equivale a IP residencial pública.
- «No Leak» y campos vacíos con prueba ejecutada: sin direcciones expuestas en esa prueba.
- API disponible con cero candidatos: no es contradictorio.
- Error JavaScript o página incompleta: inconcluso.

No concedas cámara, micrófono o ubicación solo para obtener un resultado favorable. Registra los permisos existentes; otros permisos pueden cambiar el escenario. Tras ajustes WebRTC, prueba una llamada autorizada. [RFC 8828](https://www.rfc-editor.org/rfc/rfc8828.html)

## IPv6 y transiciones

Comprueba resolución, ruta y acceso a un destino IPv6 conocido desde cada cliente. Clasifica el error: DNS, conexión, proxy o timeout. «No alcanzable» no demuestra que IPv6 esté desactivado ni que todas las interfaces lo bloqueen.

Para probar kill switch, coordina una interrupción y cierra o pausa actividad sensible. Registra qué evento se prueba: caída del túnel, desconexión manual, arranque, suspensión o cambio de red; el comportamiento puede diferir.

Durante el evento, un cliente de prueba intenta conexiones a un destino aceptado y registra éxito, fallo y salida observada. Aprobar requiere que no aparezca la salida directa en la muestra y que se recupere la salida prevista al reconectar. Una prueba puntual no demuestra ausencia de intervalos más cortos que el muestreo.

Cada escenario no ejecutado permanece pendiente. Usa el [registro de evidencia](evidencia-y-cambios.md) y no extrapoles navegador a CLI, Windows a WSL2 ni VPN conectada a VPN caída.
