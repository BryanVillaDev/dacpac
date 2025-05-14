@echo off
echo ========================================
echo Exportando base de datos 'test' a DACPAC
echo ========================================

setlocal
set SQLPACKAGE="C:\Program Files\Microsoft SQL Server\170\DAC\bin\SqlPackage.exe"
set SERVER=DESKTOP-Q5BBRAM
set DATABASE=test
set OUTPUT=F:\dacpac\releases\test_v1.dacpac

%SQLPACKAGE% ^
  /Action:Extract ^
  /SourceServerName:"%SERVER%" ^
  /SourceDatabaseName:"%DATABASE%" ^
  /TargetFile:"%OUTPUT%" ^
  /SourceTrustServerCertificate:True

echo.
echo Exportación completada con éxito.
echo Archivo generado en: %OUTPUT%
pause
