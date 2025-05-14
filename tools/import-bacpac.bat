@echo off
echo ========================================================
echo IMPORTANDO .BACPAC A UNA NUEVA BASE DE DATOS test_QA
echo ========================================================

setlocal
set SQLPACKAGE="C:\Program Files\Microsoft SQL Server\170\DAC\bin\SqlPackage.exe"
set SERVER=localhost
set ROOT=%~dp0..
set BACKUP_DIR=%ROOT%\backups

:: Preguntar al usuario si desea borrar y recrear test_QA
set /p CONFIRM="¿Deseas borrar y recrear la base 'test_QA'? (s/n): "

if /i not "%CONFIRM%"=="s" (
    echo ❌ Operación cancelada por el usuario.
    pause
    exit /b 0
)

:: Borrar base si ya existe
echo Eliminando base de datos 'test_QA' si existe...
sqlcmd -S %SERVER% -Q "IF DB_ID('test_QA') IS NOT NULL BEGIN ALTER DATABASE test_QA SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE test_QA; END"

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
echo ✅ Importación completada en base de datos 'test_QA'.
pause
