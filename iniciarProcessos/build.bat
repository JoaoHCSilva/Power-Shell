@echo off
#lembre-se o build será realizada no arquivo build.ps1 localizado na raiz do projeto
powershell.exe -ExecutionPolicy Bypass -File ..\build.ps1
echo Build concluido com sucesso!
pause
