@echo off
setlocal enabledelayedexpansion

:: ====== ARGUMENT PRÜFEN ======
if "%~1"=="" (
    echo [ERROR] Kein Pfad zur Datei übergeben.
    exit /b 1
)

set "TARGET=%~1"
set "BASENAME=%~n1"
set "DIR=%~dp1"
set "HASHFILE=%DIR%%BASENAME%.sha256.txt"
set "VERSIONFILE=%DIR%version.txt"

echo [INFO] Zieldatei: %TARGET%

:: ====== SHA256 BERECHNEN ======
echo [INFO] Berechne SHA256...
set "HASH="

for /f "tokens=* skip=1" %%H in ('certutil -hashfile "%TARGET%" SHA256') do (
    if not defined HASH set "HASH=%%H"
)

if not defined HASH (
    echo [ERROR] SHA256 konnte nicht berechnet werden.
    exit /b 1
)

echo %HASH% > "%HASHFILE%"
echo [INFO] SHA256 gespeichert in: %HASHFILE%

:: ====== VERSION ERMITTELN ======
echo [INFO] Ermittle Versionsnummer...

powershell -nologo -noprofile ^
  -command "$v = (Get-Item '%TARGET%').VersionInfo.FileVersion; if ($v) { $v } else { 'Keine Versionsinfo gefunden' }" ^
  > "%VERSIONFILE%"

:: Ausgabe zur Kontrolle
set /p VERSION=<"%VERSIONFILE%"
echo [INFO] Versionsdatei erstellt: %VERSIONFILE%
echo [INFO] Inhalt: %VERSION%


endlocal
exit /b 0
