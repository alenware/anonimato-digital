# Privacidad y verificación de red en WSL2

WSL2 ejecuta Linux sobre Windows. La VPN puede estar en Windows mientras que el cliente que abre la conexión puede ejecutarse en Linux. Comprueba la ruta del proceso que quieres revisar. El navegador de Windows y OpenCode en Linux requieren comprobaciones independientes.

## Usar la skill dentro de Linux

Con OpenCode para Linux y Git disponibles en la distribución, ejecuta desde una terminal de WSL2 los siguientes comandos. Elige una carpeta de trabajo dentro de tu directorio personal de Linux. [Instalación de OpenCode](https://opencode.ai/docs/) · [Sistemas de archivos de Windows y Linux](https://learn.microsoft.com/en-us/windows/wsl/interop)

```bash
git clone https://github.com/alenware/anonimato-digital.git
cd anonimato-digital
opencode
```

En OpenCode escribe `Usa @anonimato-digital para revisar la conexión de este cliente en WSL2`. Si ya tienes el repositorio en Linux, actualiza la copia con `git pull --ff-only` y abre el proyecto.

## 1. Identifica el proceso, la ruta y el proxy

Desde PowerShell, ejecuta `wsl --list --verbose` para comprobar que tu distribución usa la versión 2. Luego ejecuta este bloque en Bash dentro de esa distribución.

```bash
if command -v wslinfo >/dev/null 2>&1; then
  wslinfo --networking-mode
fi

command -v opencode
ip -4 route show default
ip -6 route show default

for name in http_proxy https_proxy all_proxy no_proxy HTTP_PROXY HTTPS_PROXY ALL_PROXY NO_PROXY WSL_PAC_URL; do
  if printenv "$name" >/dev/null; then
    printf '%s está definida\n' "$name"
  fi
done
```

- Si `opencode` apunta a un ejecutable de Windows o a un lanzador dentro de `/mnt/c`, confirma qué binario ejecuta antes de usarlo como prueba de un cliente Linux. Si apunta a un lanzador local, revisa también cualquier servidor de OpenCode o intermediario configurado para el proveedor de IA.
- `nat` y `mirrored` describen cómo WSL conecta Linux con Windows. La tabla de rutas muestra lo que Linux conoce. Para comprobar la IP pública hace falta observar la salida. [Modos de red de WSL](https://learn.microsoft.com/en-us/windows/wsl/networking)
- `autoProxy` puede propagar la configuración HTTP de Windows. Cada cliente decide qué variables acepta y aplica sus propias exclusiones. Un valor puede contener credenciales. El bloque imprime solo los nombres de las variables definidas. [Consideraciones de autoProxy](https://learn.microsoft.com/en-us/windows/wsl/troubleshooting)
- `dnsTunneling` cambia cómo WSL entrega las consultas DNS a Windows. Si falla la resolución, comprueba `getent ahosts github.com >/dev/null` desde Linux. El éxito acredita que Linux resolvió ese nombre. Para saber por dónde salió la consulta, comprueba el resolver en el contexto de la aplicación. [DNS en WSL](https://learn.microsoft.com/en-us/windows/wsl/networking#dns-tunneling)

## DNS efectivo y modo de red

Lee `/etc/resolv.conf` y los ajustes relevantes de `/etc/wsl.conf` y `.wslconfig` si existen. La ausencia de `.wslconfig` no basta para certificar el modo activo: usa `wslinfo --networking-mode` cuando esté disponible y registra la versión de WSL.

`10.255.255.254` es la dirección predeterminada del resolver virtual de DNS tunneling. Es compatible con que Windows gestione las consultas; no identifica al resolver público final. `getent` confirma resolución, no su recorrido. Las aplicaciones con DoH propio requieren revisión separada. [Configuración de WSL](https://learn.microsoft.com/en-us/windows/wsl/wsl-config) · [DNS tunneling y políticas NRPT](https://learn.microsoft.com/en-us/windows/wsl/troubleshooting)

Si conviven VPN, Tailscale y un cliente DNS, identifica la función de cada uno. Confirma el exit node efectivo sin volcar listas de peers o identidades. No deduzcas su uso del proceso activo. Comprueba resultados por proceso y conserva proxies con credenciales fuera de la salida.

## 2. Comprueba la salida de Linux y Windows

Si aceptas que un verificador reciba tu IP, ejecuta ambas pruebas desde la distribución, con la VPN en el estado que quieras comprobar. Para comparar, puedes ejecutar los mismos comandos con `curl.exe` desde PowerShell en Windows. Conserva las direcciones en local y registra solo si observaste la salida esperada. [API de ipify](https://www.ipify.org/)

```bash
curl -4 -fsS --max-time 10 'https://api.ipify.org?format=json'
curl -6 -fsS --max-time 10 'https://api6.ipify.org?format=json'
```

El resultado corresponde a ese destino y a la configuración del cliente que hizo la petición. Si el cliente usa un proxy, el verificador puede recibir la IP del proxy. La prueba de IPv6 puede fallar por falta de ruta, DNS, proxy o conectividad. Una salida esperada en `curl` deja pendiente la comprobación de OpenCode si su servidor o proveedor usa otro proxy, otra red o un contenedor. Comprueba también el comportamiento durante una caída de VPN si tu objetivo abarca ese caso y puedes interrumpir la conexión sin afectar trabajo activo.

## 3. Revisa archivos y ajustes del sistema correspondiente

- Los programas de Linux pueden leer archivos de Windows en las unidades montadas bajo `/mnt/` según los permisos de acceso. Antes de adjuntar archivos a un chat, comprueba si vienen de una carpeta sincronizada y revisa el contenido de la copia que enviarás. Consulta la [guía para Windows](guia-windows.md) para OneDrive, permisos del navegador de Windows y diagnóstico del sistema anfitrión. [Interoperabilidad de archivos](https://learn.microsoft.com/en-us/windows/wsl/interop)
- Si hay que diagnosticar o ajustar WSL, revisa el alcance. `.wslconfig` afecta a todas las distribuciones WSL2 del usuario y `/etc/wsl.conf` afecta a una distribución. Algunos cambios de `.wslconfig` requieren `wsl --shutdown`, que detiene todas las distribuciones en ejecución. Si cambias un ajuste, guarda el valor anterior y repite las pruebas después de arrancar. [Configuración de WSL](https://learn.microsoft.com/en-us/windows/wsl/wsl-config)
