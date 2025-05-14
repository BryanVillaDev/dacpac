@echo off
echo ========================================================
echo EXPORTANDO BASE COMPLETA (ESQUEMA + DATOS) COMO .BACPAC
echo ========================================================

setlocal
set SQLPACKAGE="C:\Program Files\Microsoft SQL Server\170\DAC\bin\SqlPackage.exe"
set SERVER=DESKTOP-Q5BBRAM
set DATABASE=test
set ROOT=%~dp0..
set BACKUP_DIR=%ROOT%\backups

:: Crear carpeta si no existe
if not exist "%BACKUP_DIR%" (
    mkdir "%BACKUP_DIR%"
)

:: Generar nombre con timestamp
for /f %%a in ('powershell -command "Get-Date -Format yyyyMMdd_HHmmss"') do set DATE=%%a
set OUTPUT=%BACKUP_DIR%\test_%DATE%.bacpac

%SQLPACKAGE% ^
  /Action:Export ^
  /SourceServerName:"%SERVER%" ^
  /SourceDatabaseName:"%DATABASE%" ^
  /TargetFile:"%OUTPUT%" ^
  /SourceTrustServerCertificate:True

echo.
echo  Exportación completada: %OUTPUT%
pause
