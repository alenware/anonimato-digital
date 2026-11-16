#requires -Version 5.1
<#
.SYNOPSIS
Inventario de privacidad de solo lectura. Emite JSON de campos seleccionados.
.DESCRIPTION
Lee valores seleccionados, servicios, perfiles y recuentos. La presencia de una
politica se registra como configuracion escrita, pendiente de verificar en la app.
La salida contiene metadatos del equipo y debe revisarse antes de compartirla.
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$auditErrors = [System.Collections.Generic.List[object]]::new()

function Read-RegistrySetting {
    param([string]$Path, [string]$Name)
    try {
        if (-not (Test-Path -LiteralPath $Path)) {
            return [ordered]@{ Present = $false }
        }
        $key = Get-Item -LiteralPath $Path
        if ($key.GetValueNames() -notcontains $Name) {
            return [ordered]@{ Present = $false }
        }
        return [ordered]@{
            Present = $true
            Kind = $key.GetValueKind($Name).ToString()
            Value = $key.GetValue($Name)
        }
    } catch {
        $auditErrors.Add([ordered]@{ Check = $Name; ErrorType = $_.Exception.GetType().Name })
        return [ordered]@{ Present = $null; Status = 'Unreadable' }
    }
}

function Count-Children {
    param([string]$Path, [string]$Check)
    try {
        if (-not (Test-Path -LiteralPath $Path)) { return 0 }
        return @(Get-ChildItem -LiteralPath $Path -Force).Count
    } catch {
        $auditErrors.Add([ordered]@{ Check = $Check; ErrorType = $_.Exception.GetType().Name })
        return $null
    }
}

$os = Get-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = [Security.Principal.WindowsPrincipal]::new($identity)
$settings = [ordered]@{}
$checks = @(
    @('DiagnosticPolicy', 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection', 'AllowTelemetry'),
    @('DiagnosticUserChoice', 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection', 'AllowTelemetry'),
    @('AdvertisingId', 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo', 'Enabled'),
    @('TailoredExperiences', 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy', 'TailoredExperiencesWithDiagnosticDataEnabled'),
    @('LocationConsent', 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location', 'Value'),
    @('NCSIActiveProbing', 'HKLM:\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet', 'EnableActiveProbing'),
    @('ErrorReportingDisabled', 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting', 'Disabled'),
    @('ActivityUpload', 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System', 'UploadUserActivities'),
    @('DeliveryOptimization', 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization', 'DODownloadMode'),
    @('ClipboardSync', 'HKCU:\SOFTWARE\Microsoft\Clipboard', 'EnableCloudClipboard'),
    @('InputCollection', 'HKCU:\SOFTWARE\Microsoft\InputPersonalization', 'RestrictImplicitTextCollection')
)
foreach ($check in $checks) {
    $settings[$check[0]] = Read-RegistrySetting -Path $check[1] -Name $check[2]
}

$serviceNames = @(
    'DiagTrack','dmwappushservice','WSearch','MapsBroker','lfsvc',
    'CDPSvc','WpnService','TokenBroker','tzautoupdate','NlaSvc',
    'BFE','MpsSvc','wuauserv','WinDefend'
)
$allServices = @(Get-Service)
$services = foreach ($name in $serviceNames) {
    $service = $allServices | Where-Object Name -EQ $name
    if ($service) {
        [ordered]@{ Name = $name; Status = $service.Status.ToString(); StartType = $service.StartType.ToString() }
    } else {
        [ordered]@{ Name = $name; Status = 'Missing'; StartType = $null }
    }
}

$taskSpecs = @(
    @('\Microsoft\Windows\Customer Experience Improvement Program\', 'Consolidator'),
    @('\Microsoft\Windows\Customer Experience Improvement Program\', 'UsbCeip'),
    @('\Microsoft\Windows\Application Experience\', 'Microsoft Compatibility Appraiser'),
    @('\Microsoft\Windows\Application Experience\', 'ProgramDataUpdater'),
    @('\Microsoft\Windows\Application Experience\', 'PcaPatchDbTask')
)
$tasks = foreach ($spec in $taskSpecs) {
    try {
        $task = Get-ScheduledTask -TaskPath $spec[0] -TaskName $spec[1]
        [ordered]@{ Name = $spec[1]; State = $task.State.ToString() }
    } catch {
        [ordered]@{ Name = $spec[1]; State = 'Unavailable'; ErrorType = $_.Exception.GetType().Name }
    }
}

$startup = foreach ($scope in @('HKCU', 'HKLM')) {
    foreach ($runKey in @('Run', 'RunOnce')) {
        $path = $scope + ':\SOFTWARE\Microsoft\Windows\CurrentVersion\' + $runKey
        try {
            $names = @()
            if (Test-Path -LiteralPath $path) { $names = @((Get-Item -LiteralPath $path).GetValueNames()) }
            [ordered]@{ Scope = $scope; Key = $runKey; EntryNames = $names }
        } catch {
            $auditErrors.Add([ordered]@{ Check = "$scope/$runKey"; ErrorType = $_.Exception.GetType().Name })
        }
    }
}

$browsers = @(
    @{ Name='Brave'; Data='BraveSoftware\Brave-Browser\User Data'; Policy='BraveSoftware\Brave' },
    @{ Name='Chrome'; Data='Google\Chrome\User Data'; Policy='Google\Chrome' },
    @{ Name='Edge'; Data='Microsoft\Edge\User Data'; Policy='Microsoft\Edge' }
)
$policyNames = @(
    'WebRtcIPHandlingPolicy','WebRtcLocalhostIpHandling','DiagnosticData',
    'MetricsReportingEnabled','BraveP3AEnabled','BraveUsagePingEnabled',
    'SpellCheckServiceEnabled','SearchSuggestEnabled','NetworkPredictionOptions',
    'BrowserSignin','SyncDisabled','BackgroundModeEnabled','PasswordManagerEnabled',
    'SafeBrowsingProtectionLevel','SafeBrowsingEnabled','SmartScreenEnabled'
)
$browserResults = foreach ($browser in $browsers) {
    $policies = [ordered]@{}
    foreach ($scope in @('HKCU','HKLM')) {
        $values = [ordered]@{}
        foreach ($name in $policyNames) {
            $path = $scope + ':\SOFTWARE\Policies\' + $browser.Policy
            $value = Read-RegistrySetting -Path $path -Name $name
            if ($value.Present -ne $false) { $values[$name] = $value }
        }
        $policies[$scope] = $values
    }
    $base = Join-Path $env:LOCALAPPDATA $browser.Data
    $profiles = @()
    if (Test-Path -LiteralPath $base) {
        $index = 0
        foreach ($dir in Get-ChildItem -LiteralPath $base -Directory) {
            if ($dir.Name -ne 'Default' -and $dir.Name -notmatch '^Profile \d+$') { continue }
            $prefPath = Join-Path $dir.FullName 'Preferences'
            if (-not (Test-Path -LiteralPath $prefPath)) { continue }
            $index++
            try {
                $pref = Get-Content -LiteralPath $prefPath -Raw | ConvertFrom-Json
                $profiles += [ordered]@{
                    ProfileIndex = $index
                    WebRTC = $pref.webrtc.ip_handling_policy
                    Languages = $pref.intl.accept_languages
                    DoNotTrack = $pref.enable_do_not_track
                    AccountRecords = @($pref.account_info | Where-Object { $null -ne $_ }).Count
                    LocationDefault = $pref.profile.default_content_setting_values.geolocation
                    LocationExceptionCount = @($pref.profile.content_settings.exceptions.geolocation.PSObject.Properties | Where-Object { $null -ne $_ }).Count
                    PreferenceBackupPresent = Test-Path -LiteralPath ($prefPath + '.bak')
                }
            } catch {
                $auditErrors.Add([ordered]@{ Check = $browser.Name + '/Preferences'; ErrorType = $_.Exception.GetType().Name })
            }
        }
    }
    [ordered]@{ Browser = $browser.Name; DataDirectoryPresent = Test-Path -LiteralPath $base; Policies = $policies; Profiles = $profiles }
}

$accountSource = 'Unverified'
try {
    $account = Get-LocalUser -SID $identity.User
    $accountSource = [string]$account.PrincipalSource
} catch {
    $auditErrors.Add([ordered]@{ Check = 'AccountSource'; ErrorType = $_.Exception.GetType().Name })
}
$processNames = @(Get-Process | Select-Object -ExpandProperty ProcessName -Unique)
$networkProcesses = @($processNames | Where-Object { $_ -match '^(ProtonVPN|tailscale|NextDNS|OneDrive|GoogleDriveFS|utorrent|qbittorrent)' })
$desktopPath = [Environment]::GetFolderPath('Desktop')
$recent = Join-Path $env:APPDATA 'Microsoft\Windows\Recent'

[ordered]@{
    CollectedAt = (Get-Date).ToUniversalTime().ToString('o')
    Scope = 'Read-only local configuration; browser policies require effective-state verification'
    OS = [ordered]@{ Edition = $os.EditionID; DisplayVersion = $os.DisplayVersion; Build = $os.CurrentBuild; UBR = $os.UBR }
    Elevated = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    Settings = $settings
    Services = @($services)
    Tasks = @($tasks)
    StartupRegistry = @($startup)
    StartupFolderCounts = [ordered]@{
        User = Count-Children ([Environment]::GetFolderPath('Startup')) 'UserStartup'
        Common = Count-Children ([Environment]::GetFolderPath('CommonStartup')) 'CommonStartup'
    }
    Browsers = @($browserResults)
    Identity = [ordered]@{
        WindowsAccountSource = $accountSource
        OneDriveAccountKeyCount = Count-Children 'HKCU:\SOFTWARE\Microsoft\OneDrive\Accounts' 'OneDrive'
        DesktopPathContainsOneDrive = $desktopPath -match '[\\/]OneDrive([\\/]| - )'
    }
    Region = [ordered]@{ Culture = (Get-Culture).Name; TimeZone = (Get-TimeZone).Id; GeoId = (Get-WinHomeLocation).GeoId }
    Artifacts = [ordered]@{
        RecentEntryCount = Count-Children $recent 'Recent'
        AutomaticDestinationCount = Count-Children (Join-Path $recent 'AutomaticDestinations') 'JumpLists'
    }
    RelevantProcesses = $networkProcesses
    Errors = @($auditErrors.ToArray())
} | ConvertTo-Json -Depth 12
