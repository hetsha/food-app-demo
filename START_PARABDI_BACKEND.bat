@echo off
REM ============================================================================
REM START_PARABDI_BACKEND.bat - Detached NestJS backend launcher.
REM Started by START_PARABDI_DEV.ps1 via `start`, so the backend keeps running
REM after the parent shell / IDE terminal exits.
REM ============================================================================
setlocal
cd /d "%~dp0backend"
if not exist "logs" mkdir "logs"
if exist "d:\upparactechnologysite\node-v20.15.0-win-x64\npm.cmd" (
  set "NPM=d:\upparactechnologysite\node-v20.15.0-win-x64\npm.cmd"
) else (
  set "NPM=npm.cmd"
)
"%NPM%" run start:dev >> "logs\backend.log" 2>&1
endlocal
