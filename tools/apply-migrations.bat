@echo off
echo ================================================
echo APLICANDO MIGRACIONES SOBRE LA BASE 'test_QA'
echo ================================================

setlocal
set SERVER=localhost
set DATABASE=test_QA
set ROOT=%~dp0..\..
set MIGRATIONS_DIR=%ROOT%\migrations

REM Verificar si la carpeta de migraciones existe
if not exist "%MIGRATIONS_DIR%" (
    echo ❌ ERROR: La carpeta %MIGRATIONS_DIR% no existe.
    pause
    exit /b 1
)

REM Verificar si hay archivos .sql
dir /b "%MIGRATIONS_DIR%\*.sql" >nul 2>&1
if errorlevel 1 (
    echo  No se encontraron scripts de migración en %MIGRATIONS_DIR%.
    pause
    exit /b 0
)

echo Ejecutando migraciones desde %MIGRATIONS_DIR%...

for %%f in ("%MIGRATIONS_DIR%\*.sql") do (
    echo -------------------------------------------------
    echo Ejecutando: %%~nxf
    sqlcmd -S %SERVER% -d %DATABASE% -E -i "%%f"
)

echo.
echo  Todas las migraciones fueron aplicadas.
pause
