@echo off
echo ===========================================
echo Publicando DACPAC sobre base de datos test_QA
echo ===========================================

setlocal
set SQLPACKAGE="C:\Program Files\Microsoft SQL Server\170\DAC\bin\SqlPackage.exe"
set SERVER=DESKTOP-Q5BBRAM
set DATABASE=test_QA
set DACPAC=F:\dacpac\releases\test_v1.dacpac

%SQLPACKAGE% ^
  /Action:Publish ^
  /SourceFile:"%DACPAC%" ^
  /TargetServerName:"%SERVER%" ^
  /TargetDatabaseName:"%DATABASE%" ^
  /p:BlockOnPossibleDataLoss=False ^
  /TargetTrustServerCertificate:True

echo.
echo  Publicación completada en la base '%DATABASE%'.
pause
