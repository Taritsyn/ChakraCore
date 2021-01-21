@echo off
setlocal

PowerShell -NoProfile -NoLogo -ExecutionPolicy Bypass -Command "[System.Threading.Thread]::CurrentThread.CurrentCulture = ''; [System.Threading.Thread]::CurrentThread.CurrentUICulture = '';& '%~dp0pack.ps1' %*; exit $LASTEXITCODE"
