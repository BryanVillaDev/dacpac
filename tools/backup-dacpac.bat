@echo off
echo ========================================
echo EXPORTANDO BASE DE DATOS 'test' A DACPAC
echo ========================================

setlocal
set SQLPACKAGE="C:\Program Files\Microsoft SQL Server\170\DAC\bin\SqlPackage.exe"
set SERVER=DESKTOP-Q5BBRAM
set DATABASE=test

:: Calcular ruta base del repo desde /tools (solo subir un nivel)
set ROOT=%~dp0..

:: Ruta absoluta a releases
set RELEASE_DIR=%ROOT%\releases

:: Crear carpeta releases si no existe
if not exist "%RELEASE_DIR%" (
    mkdir "%RELEASE_DIR%"
)

:: Generar nombre de archivo con fecha
for /f %%a in ('powershell -command "Get-Date -Format yyyyMMdd_HHmmss"') do set DATE=%%a
set OUTPUT=%RELEASE_DIR%\test_%DATE%.dacpac

%SQLPACKAGE% ^
  /Action:Extract ^
  /SourceServerName:"%SERVER%" ^
  /SourceDatabaseName:"%DATABASE%" ^
  /TargetFile:"%OUTPUT%" ^
  /SourceTrustServerCertificate:True

echo.
echo  Exportación completada con éxito.
echo Archivo generado en: %OUTPUT%
pause
