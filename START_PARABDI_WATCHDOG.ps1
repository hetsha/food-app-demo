# ============================================================================
# START_PARABDI_WATCHDOG.ps1 - Keeps the Parabdi NestJS backend alive.
# ----------------------------------------------------------------------------
# The backend used to be started as a direct child of whatever shell launched
# it. When that shell received a Ctrl+C (IDE terminal, script exit, etc.) the
# NestJS process died with it, port 3000 went silent and the app started
# reporting "Failed to load foods" and empty Home sections.
#
# This watchdog runs detached from any interactive console and:
#   * starts the backend when port 3000 is not serving /api/v1/health
#   * frees port 3000 when another project is holding it (health check fails)
#   * restarts the backend automatically when it exits or becomes unhealthy
#
# Status trail: backend\logs\watchdog.log
# Started/verified by START_PARABDI_DEV.ps1 (idempotent, non-destructive).
# Never runs: prisma migrate reset / db push / drop / docker volume rm.
# ============================================================================
$ErrorActionPreference = 'Continue'

$ProjectRoot = $PSScriptRoot
if (-not $ProjectRoot) { $ProjectRoot = (Get-Location).Path }
$BackendDir = Join-Path $ProjectRoot 'backend'
$BackendBat = Join-Path $ProjectRoot 'START_PARABDI_BACKEND.bat'
$WatchdogPidFile = Join-Path $BackendDir 'logs\watchdog.pid'
$WatchdogLog = Join-Path $BackendDir 'logs\watchdog.log'
$HealthUrl = 'http://127.0.0.1:3000/api/v1/health'

function Write-WatchLog([string]$Message) {
    $line = '{0} {1}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Message
    try { Add-Content -Path $WatchdogLog -Value $line -Encoding utf8 } catch { }
}

function Test-Healthy {
    try {
        $r = Invoke-WebRequest -Uri $HealthUrl -UseBasicParsing -TimeoutSec 3
        return ($r.StatusCode -eq 200)
    } catch { return $false }
}

function Get-PortOwner {
    $c = Get-NetTCPConnection -LocalPort 3000 -State Listen -ErrorAction SilentlyContinue |
         Select-Object -First 1
    if ($c) { return $c.OwningProcess }
    return $null
}

function Get-DescendantIds([int]$RootId) {
    $all = @(Get-CimInstance Win32_Process -ErrorAction SilentlyContinue)
    $children = @{}
    foreach ($p in $all) {
        if (-not $children.ContainsKey($p.ParentProcessId)) { $children[$p.ParentProcessId] = @() }
        $children[$p.ParentProcessId] += $p.ProcessId
    }
    $stack = New-Object System.Collections.Stack
    $stack.Push($RootId)
    $result = @()
    while ($stack.Count -gt 0) {
        $id = $stack.Pop()
        $kids = $children[$id]
        if ($kids) {
            foreach ($k in $kids) { $result += $k; $stack.Push($k) }
        }
    }
    return $result
}

function Stop-BackendTree {
    # Kills leftover launcher/cmd/nest/node chains that belong to this project
    # so a fresh, clean instance can bind port 3000.
    $launchers = @(Get-CimInstance Win32_Process -Filter "Name = 'cmd.exe'" -ErrorAction SilentlyContinue |
        Where-Object { $_.CommandLine -and $_.CommandLine -like '*START_PARABDI_BACKEND*' })
    $dead = @()
    foreach ($l in $launchers) {
        $dead += Get-DescendantIds -RootId $l.ProcessId
        $dead += $l.ProcessId
    }
    # Orphans whose launcher already exited (e.g. nest watch left behind).
    $orphans = @(Get-CimInstance Win32_Process -ErrorAction SilentlyContinue |
        Where-Object {
            $_.ProcessId -ne $PID -and $_.CommandLine -and (
                $_.CommandLine -like '*@nestjs\cli\bin\nest.js*' -or
                $_.CommandLine -like '*food-app-demo\backend\node_modules*'
            )
        })
    foreach ($o in $orphans) { $dead += $o.ProcessId }

    $dead = $dead | Where-Object { $_ } | Sort-Object -Unique
    foreach ($procId in $dead) {
        if ($procId -eq $PID) { continue }
        Stop-Process -Id $procId -Force -ErrorAction SilentlyContinue
    }
    if ($dead.Count -gt 0) { Write-WatchLog "stopped stale backend processes: $($dead -join ',')" }

    $deadline = (Get-Date).AddSeconds(15)
    while ((Get-Date) -lt $deadline) {
        if (-not (Get-PortOwner)) { return $true }
        Start-Sleep -Seconds 2
    }
    return (-not (Get-PortOwner))
}

function Release-Port {
    param([int]$DelaySeconds = 20)
    $owner = Get-PortOwner
    if (-not $owner) { return $true }

    # Give a booting Parabdi instance (or a foreign server) time first.
    $deadline = (Get-Date).AddSeconds($DelaySeconds)
    while ((Get-Date) -lt $deadline) {
        if (Test-Healthy) { return $true }
        Start-Sleep -Seconds 3
    }
    if (Test-Healthy) { return $true }

    Write-WatchLog "releasing port 3000 from unhealthy PID $owner"
    Stop-Process -Id $owner -Force -ErrorAction SilentlyContinue
    $deadline = (Get-Date).AddSeconds(15)
    while ((Get-Date) -lt $deadline) {
        if (-not (Get-PortOwner)) { return $true }
        Start-Sleep -Seconds 2
    }
    return (-not (Get-PortOwner))
}

function Start-Backend {
    if (-not (Test-Path $BackendBat)) {
        Write-WatchLog "FATAL launcher missing: $BackendBat"
        return $false
    }
    try {
        # Own (hidden) console: a Ctrl+C sent to any other console cannot reach it.
        $proc = Start-Process -FilePath 'cmd.exe' `
            -ArgumentList '/c', ('"' + $BackendBat + '"') `
            -WindowStyle Hidden -PassThru -ErrorAction Stop
        Write-WatchLog "launching backend (launcher PID $($proc.Id))"
        return $true
    } catch {
        Write-WatchLog "ERROR launching backend: $($_.Exception.Message)"
        return $false
    }
}

# --- single instance guard --------------------------------------------------
if (Test-Path $WatchdogPidFile) {
    $existingPid = Get-Content $WatchdogPidFile -ErrorAction SilentlyContinue
    if ($existingPid) {
        $proc = Get-Process -Id ([int]$existingPid) -ErrorAction SilentlyContinue
        if ($proc) { exit 0 }   # watchdog already running
    }
}

$dir = Split-Path $WatchdogPidFile
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
Set-Content -Path $WatchdogPidFile -Value $PID -Encoding ascii
Write-WatchLog "watchdog started (PID $PID)"

try {
    while ($true) {
        if (Test-Healthy) {
            Start-Sleep -Seconds 5
            continue
        }

        Write-WatchLog "backend unhealthy; portOwner=$((Get-PortOwner))"

        if (Get-PortOwner) {
            # Something owns 3000 but does not answer the health check:
            # a booting backend, a stuck instance or another project.
            if (-not (Release-Port)) {
                Write-WatchLog "could not release port 3000 - retrying"
                Start-Sleep -Seconds 5
                continue
            }
            if (Test-Healthy) { Start-Sleep -Seconds 5; continue }
        }

        # Port is free but nothing is serving: clear stale chains and start.
        Stop-BackendTree | Out-Null
        if (Start-Backend) {
            $deadline = (Get-Date).AddSeconds(90)
            while ((Get-Date) -lt $deadline) {
                if (Test-Healthy) { break }
                Start-Sleep -Seconds 3
            }
            if (Test-Healthy) {
                Write-WatchLog "backend healthy again"
            } else {
                Write-WatchLog "backend failed to become healthy within 90s"
                Stop-BackendTree | Out-Null
            }
        }
        Start-Sleep -Seconds 5
    }
} finally {
    Remove-Item -Path $WatchdogPidFile -Force -ErrorAction SilentlyContinue
    Write-WatchLog "watchdog stopped"
}
