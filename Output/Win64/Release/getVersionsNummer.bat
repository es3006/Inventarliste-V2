@echo off
setlocal

:: Prüfen, ob Datei übergeben wurde
if "%~1"=="" (
    echo ❌ Bitte ziehe eine EXE-Datei auf dieses Script.
    pause
    exit /b 1
)

set "TARGET=%~1"

:: Versionsnummer auslesen mit PowerShell
for /f "delims=" %%V in ('powershell -nologo -noprofile -command "(Get-Item -LiteralPath '%TARGET%').VersionInfo.FileVersion"') do (
    set "VERSION=%%V"
)

:: Versionsnummer anzeigen
if defined VERSION (
    echo ✅ Versionsnummer von "%TARGET%":
    echo    %VERSION%
) else (
    echo ❌ Konnte Versionsnummer nicht auslesen.
)

endlocal
pause
exit /b 0
