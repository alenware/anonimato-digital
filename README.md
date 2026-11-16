# Anonimato digital

Skill de OpenCode para revisar qué datos expone una aplicación en Windows y WSL2, investigar fugas de red y aplicar ajustes de privacidad con verificación y restauración.

Está dirigida a desarrolladores y a personas que quieren entender qué comparte su equipo. El agente explica el resultado en lenguaje cotidiano y conserva los detalles necesarios para reproducirlo: proceso, perfil, configuración, prueba y evidencia.

## Qué hace

| Área | Comprobaciones | Resultado |
| --- | --- | --- |
| IP y VPN | Salida IPv4/IPv6 del cliente, proxy y exclusiones del túnel | Si la conexión probada utiliza la salida esperada |
| DNS | Resolver, política NRPT de Windows, DNS seguro del navegador y resolución desde WSL2 | Proveedores observados y discrepancias; recorrido cuando existe evidencia de tráfico |
| WebRTC | Candidatos expuestos por el navegador y permisos de la sesión | Direcciones observadas y efecto de las restricciones |
| Windows | Edición, valores y tipos del registro, servicios, tareas y aplicaciones de inicio | Inventario local y ajustes que requieren comprobarse en su interfaz |
| Navegadores | Políticas aceptadas, permisos, métricas, sincronización y perfiles | Diferencia entre configuración escrita y protección efectiva |
| WSL2 | Proceso que conecta, modo de red, resolver y proxy | Diagnóstico separado de Linux y Windows |
| Servicios de IA | Cuenta, permisos de ubicación, adjuntos y contexto del cliente | Vías de exposición que siguen existiendo con la IP protegida |

Incluye instrucciones, procedimientos y un recolector local de Windows. Las pruebas de red se realizan con las herramientas disponibles o con capturas aportadas por el usuario. No instala una VPN ni aplica un paquete automático de cambios.

## Qué significa un resultado

Cada comprobación se clasifica como **verificada en el contexto probado**, **discrepancia**, **inconclusa** o **no ejecutada**.

- Una IP de la VPN acredita la salida de esa solicitud, no la de todas las aplicaciones.
- Una prueba DNS con cero servidores queda inconclusa.
- Un proveedor distinto en la lista DNS requiere atribución. No demuestra por sí solo una fuga ni un falso positivo.
- Un timeout IPv6 acredita un fallo de conectividad en esa prueba, no bloqueo permanente.
- WebRTC sin candidatos expuestos es una observación válida si la prueba se ejecutó. No demuestra que la API esté deshabilitada.
- Una cuenta iniciada permite asociar actividad al usuario aunque cambie su IP.

El informe puede concluir «no se observaron fugas en los clientes y escenarios probados» cuando la evidencia lo respalde. No certifica anonimato, ubicación indetectable ni un porcentaje de protección.

## Instalación

Con Git y OpenCode disponibles:

```sh
git clone https://github.com/alenware/anonimato-digital.git
cd anonimato-digital
opencode
```

OpenCode descubre la skill en `.opencode/skills/anonimato-digital/SKILL.md`. Para otro proyecto, copia la carpeta completa, incluidos `references/` y `scripts/`, a su directorio `.opencode/skills/`. [Documentación de skills](https://opencode.ai/docs/skills/)

En WSL2, comprueba con `command -v opencode` qué lanzador utilizas y qué binario ejecuta. Un lanzador en una unidad de Windows puede iniciar un proceso de Windows. El recolector PowerShell se ejecuta en Windows; los procedimientos Linux, en la distribución correspondiente.

## Uso

```text
Usa la skill anonimato-digital para revisar Brave con mi VPN conectada.
Comprueba IP, DNS y WebRTC. Explica qué demuestra cada resultado,
qué queda pendiente y qué ajustes resolverían los hallazgos.
```

```text
Usa la skill anonimato-digital para diagnosticar mi cliente de IA en WSL2.
Identifica el proceso que conecta, el DNS y el proxy.
Distingue la exposición de red de los datos que envío con mi cuenta.
```

Para implementar correcciones, indica qué aplicaciones y ajustes quieres incluir. El agente conserva el estado anterior, aplica cambios dentro del alcance solicitado y repite las pruebas. Las pruebas de caída de VPN y los reinicios se coordinan porque pueden interrumpir trabajo activo.

## Inventario local de Windows

Desde la raíz del repositorio, en PowerShell de Windows:

```powershell
& ./.opencode/skills/anonimato-digital/scripts/audit-windows.ps1 |
    Set-Content -LiteralPath "$env:TEMP/anonimato-inventario.json" -Encoding UTF8
```

El script consulta configuración local y emite JSON. No cambia ajustes ni realiza consultas de red. Incluye servicios, tareas seleccionadas, entradas de inicio, políticas y preferencias de perfiles convencionales de Brave, Chrome y Edge.

El inventario contiene información del equipo: revísalo antes de compartirlo. No exporta cookies, contraseñas, nombres de cuenta ni contenido de archivos personales. Las políticas detectadas deben verificarse dentro del navegador; los perfiles personalizados y otros usuarios quedan fuera de la detección automática.

## Procedimiento

1. Definir el dato a proteger, su observador y el cliente que origina la conexión.
2. Registrar configuración y pruebas iniciales con fecha, perfil y estado de VPN.
3. Relacionar cada discrepancia con una hipótesis comprobable.
4. Aplicar el ajuste solicitado con respaldo del valor y tipo anteriores.
5. Repetir la prueba y comprobar las funciones afectadas.
6. Entregar evidencia, cambios, restauración y pendientes.

Las páginas de prueba reciben la IP y datos técnicos de la sesión que las visita. Una prueba en un navegador integrado, una herramienta remota o `curl` se atribuye a ese cliente.

## Validación y límites

Se han ejecutado el inventario local de Windows, consultas DNS en Windows y resolución en Ubuntu bajo WSL2. También se han interpretado capturas de IPLeak y BrowserLeaks identificando el navegador de origen. Estos ejercicios validan procedimientos y criterios de lectura; no certifican otros equipos ni todas las combinaciones de VPN, versiones y perfiles.

Las pruebas de caída del túnel, reconexión, tráfico por interfaz y funcionamiento después de cada corrección requieren ejecución específica. El recolector no realiza esas pruebas. Los informes personales y las capturas no forman parte del repositorio público.

## Documentación

- [Instrucciones de la skill](.opencode/skills/anonimato-digital/SKILL.md)
- [Pruebas de red y criterios de evidencia](.opencode/skills/anonimato-digital/references/pruebas-de-red.md)
- [Windows, navegadores e inventario](.opencode/skills/anonimato-digital/references/guia-windows.md)
- [Diagnóstico de WSL2](.opencode/skills/anonimato-digital/references/guia-wsl2.md)
- [Ubicación e identidad ante servicios de IA](.opencode/skills/anonimato-digital/references/privacidad-ia.md)
- [Registro de cambios, restauración e informe](.opencode/skills/anonimato-digital/references/evidencia-y-cambios.md)
