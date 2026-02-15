@echo off
title Template Node App - GUI
echo Compilando e iniciando Template Node App GUI...

REM Adiciona dotnet ao PATH se necessário
set "PATH=C:\Program Files\dotnet;%PATH%"

REM Compila e executa o projeto
dotnet run --project "%~dp0..\TemplateNodeAppGUI.csproj"

if errorlevel 1 (
    echo.
    echo [ERRO] Falha ao executar o projeto.
    echo Verifique se o .NET 8 SDK esta instalado: dotnet --version
    pause
)
