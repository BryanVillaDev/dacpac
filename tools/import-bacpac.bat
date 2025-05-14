@echo off
echo ========================================================
echo IMPORTANDO .BACPAC A UNA NUEVA BASE DE DATOS test_QA
echo ========================================================

setlocal
set SQLPACKAGE="C:\Program Files\Microsoft SQL Server\170\DAC\bin\SqlPackage.exe"
set SERVER=localhost
set ROOT=%~dp0..
set BACKUP_DIR=%ROOT%\backups

:: Buscar el archivo .bacpac más reciente
for /f "delims=" %%f in ('dir /b /o-d "%BACKUP_DIR%\\*.bacpac"') do (
    set "BACPAC=%%f"
    goto :found
)

:found
if not defined BACPAC (
    echo ❌ ERROR: No se encontró ningún archivo .bacpac en %BACKUP_DIR%
    pause
    exit /b 1
)

set "BACPAC=%BACKUP_DIR%\\%BACPAC%"
echo Usando archivo: %BACPAC%

%SQLPACKAGE% ^
  /Action:Import ^
  /TargetServerName:"%SERVER%" ^
  /TargetDatabaseName:"test_QA" ^
  /SourceFile:"%BACPAC%" ^
  /TargetTrustServerCertificate:True

echo.
echo  Importación completada en base de datos 'test_QA'.
pause
