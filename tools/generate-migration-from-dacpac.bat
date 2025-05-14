@echo off
echo ===================================================
echo GENERANDO SCRIPT DE MIGRACION DESDE EL ULTIMO DACPAC
echo ===================================================

setlocal
set SQLPACKAGE="C:\Program Files\Microsoft SQL Server\170\DAC\bin\SqlPackage.exe"
set SERVER=localhost
set DATABASE=test
set ROOT=%~dp0..
set RELEASE_DIR=%ROOT%\releases
set MIGRATIONS_DIR=%ROOT%\migrations

REM Verificar que existan .dacpac
for /f "delims=" %%f in ('dir /b /o-d "%RELEASE_DIR%\*.dacpac"') do (
    set "DACPAC=%%f"
    goto :found
)

:found
if not defined DACPAC (
    echo ❌ ERROR: No se encontró ningún archivo .dacpac en %RELEASE_DIR%
    pause
    exit /b 1
)

set "DACPAC=%RELEASE_DIR%\%DACPAC%"
echo Usando archivo: %DACPAC%

REM Crear carpeta de migraciones si no existe
if not exist "%MIGRATIONS_DIR%" (
    mkdir "%MIGRATIONS_DIR%"
)

REM Generar nombre del archivo de salida
for /f %%a in ('powershell -command "Get-Date -Format yyyyMMdd_HHmmss"') do set DATE=%%a
set OUTPUT=%MIGRATIONS_DIR%\generated_migration_%DATE%.sql

%SQLPACKAGE% ^
  /Action:Script ^
  /SourceFile:"%DACPAC%" ^
  /TargetServerName:"%SERVER%" ^
  /TargetDatabaseName:"%DATABASE%" ^
  /OutputPath:"%OUTPUT%" ^
  /p:BlockOnPossibleDataLoss=True ^
  /TargetTrustServerCertificate:True

echo.
echo  Script de migración generado: %OUTPUT%
pause
