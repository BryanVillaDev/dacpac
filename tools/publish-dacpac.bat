@echo off
echo ===========================================
echo ACTUALIZANDO REPOSITORIO LOCAL
echo ===========================================

cd /d %~dp0
git pull origin main

echo ===========================================
echo BUSCANDO EL ÚLTIMO ARCHIVO .DACPAC DISPONIBLE
echo ===========================================

setlocal
set SQLPACKAGE="C:\Program Files\Microsoft SQL Server\170\DAC\bin\SqlPackage.exe"
set SERVER=localhost
set DATABASE=test_QA
set ROOT=%~dp0..\..
set RELEASE_DIR=%ROOT%\releases

REM Buscar el archivo .dacpac más reciente
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

echo ===========================================
echo PUBLICANDO DACPAC SOBRE LA BASE %DATABASE%
echo ===========================================

%SQLPACKAGE% ^
  /Action:Publish ^
  /SourceFile:"%DACPAC%" ^
  /TargetServerName:"%SERVER%" ^
  /TargetDatabaseName:"%DATABASE%" ^
  /p:BlockOnPossibleDataLoss=True ^
  /TargetTrustServerCertificate:True

echo.
echo  Publicación completada en la base '%DATABASE%'.
pause
