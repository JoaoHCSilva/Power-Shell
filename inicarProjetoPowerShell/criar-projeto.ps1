# ============================================
# Script para criar estrutura de projeto PS1
# ============================================

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "   CRIADOR DE PROJETO POWERSHELL        " -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Solicita o nome do projeto
$nomeProjeto = Read-Host "Digite o nome do projeto"

if ([string]::IsNullOrWhiteSpace($nomeProjeto)) {
    Write-Host "ERRO: O nome do projeto nao pode ser vazio!" -ForegroundColor Red
    exit
}

# Solicita o caminho onde o projeto sera criado
$caminhoBase = Read-Host "Digite o caminho onde o projeto sera criado (ou pressione Enter para usar o diretorio atual)"

if ([string]::IsNullOrWhiteSpace($caminhoBase)) {
    $caminhoBase = Get-Location
}

# Caminho completo do projeto
$caminhoProjeto = Join-Path -Path $caminhoBase -ChildPath $nomeProjeto

# Verifica se o diretorio ja existe
if (Test-Path $caminhoProjeto) {
    Write-Host "AVISO: O diretorio '$nomeProjeto' ja existe!" -ForegroundColor Yellow
    $resposta = Read-Host "Deseja continuar e sobrescrever os arquivos? (S/N)"
    if ($resposta -ne "S" -and $resposta -ne "s") {
        Write-Host "Operacao cancelada pelo usuario." -ForegroundColor Yellow
        exit
    }
}

# Cria o diretorio do projeto
Write-Host ""
Write-Host "Criando estrutura do projeto..." -ForegroundColor Green

New-Item -ItemType Directory -Path $caminhoProjeto -Force | Out-Null

# ============================================
# Conteudo do README.md
# ============================================
$readmeContent = @"
# $nomeProjeto

## Descricao

Descreva aqui o objetivo do seu projeto PowerShell.

## Pre-requisitos

- PowerShell 5.1 ou superior
- [Liste aqui outras dependencias necessarias]

## Como Executar

### Opcao 1: Via PowerShell
``````powershell
.\main.ps1
``````

### Opcao 2: Via arquivo .bat
Clique duas vezes no arquivo ``build.bat`` ou execute no terminal:
``````cmd
build.bat
``````

## Estrutura do Projeto

``````
$nomeProjeto/
├── main.ps1       # Script principal
├── build.bat      # Arquivo para execucao rapida
├── README.md      # Documentacao do projeto
└── .gitignore     # Arquivos ignorados pelo Git
``````

## Autor

Seu Nome - [seu-email@exemplo.com]

## Licenca

Este projeto esta licenciado sob a licenca MIT.
"@

# ============================================
# Conteudo do main.ps1
# ============================================
$mainPs1Content = @"
# ============================================
# $nomeProjeto
# ============================================
# Descricao: [Descreva o objetivo do script]
# Autor: [Seu Nome]
# Data: $(Get-Date -Format "dd/MM/yyyy")
# ============================================

# Configuracoes iniciais
`$ErrorActionPreference = "Stop"

# ============================================
# FUNCOES
# ============================================

function Show-Menu {
    <#
    .SYNOPSIS
        Exibe o menu principal do script
    #>
    Clear-Host
    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "   $nomeProjeto                          " -ForegroundColor Cyan
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "[1] Opcao 1" -ForegroundColor White
    Write-Host "[2] Opcao 2" -ForegroundColor White
    Write-Host "[3] Opcao 3" -ForegroundColor White
    Write-Host "[0] Sair" -ForegroundColor Red
    Write-Host ""
}

function Invoke-Option1 {
    <#
    .SYNOPSIS
        Executa a opcao 1
    #>
    Write-Host "Executando opcao 1..." -ForegroundColor Green
    # TODO: Implemente sua logica aqui
    Read-Host "Pressione Enter para continuar"
}

function Invoke-Option2 {
    <#
    .SYNOPSIS
        Executa a opcao 2
    #>
    Write-Host "Executando opcao 2..." -ForegroundColor Green
    # TODO: Implemente sua logica aqui
    Read-Host "Pressione Enter para continuar"
}

function Invoke-Option3 {
    <#
    .SYNOPSIS
        Executa a opcao 3
    #>
    Write-Host "Executando opcao 3..." -ForegroundColor Green
    # TODO: Implemente sua logica aqui
    Read-Host "Pressione Enter para continuar"
}

# ============================================
# LOOP PRINCIPAL
# ============================================

do {
    Show-Menu
    `$opcao = Read-Host "Escolha uma opcao"
    
    switch (`$opcao) {
        "1" { Invoke-Option1 }
        "2" { Invoke-Option2 }
        "3" { Invoke-Option3 }
        "0" { 
            Write-Host "Saindo..." -ForegroundColor Yellow
            break 
        }
        default { 
            Write-Host "Opcao invalida!" -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
} while (`$opcao -ne "0")

Write-Host "Programa encerrado." -ForegroundColor Cyan
"@

# ============================================
# Conteudo do .psm1
# ============================================
$psm1Content = @"
# ============================================
# $nomeProjeto
# ============================================
# Descricao: [Descreva o objetivo do script]
# Autor: [Seu Nome]
# Data: $(Get-Date -Format "dd/MM/yyyy")
# ============================================

# Configuracoes iniciais
`$ErrorActionPreference = "Stop"

# ============================================
# FUNCOES
# ============================================

function Show-Menu {
    <#
    .SYNOPSIS
        Exibe o menu principal do script
    #>
    Clear-Host
    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "   $nomeProjeto                          " -ForegroundColor Cyan
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "[1] Opcao 1" -ForegroundColor White
    Write-Host "[2] Opcao 2" -ForegroundColor White
    Write-Host "[3] Opcao 3" -ForegroundColor White
    Write-Host "[0] Sair" -ForegroundColor Red
    Write-Host ""
}

function Invoke-Option1 {
    <#
    .SYNOPSIS
        Executa a opcao 1
    #>
    Write-Host "Executando opcao 1..." -ForegroundColor Green
    # TODO: Implemente sua logica aqui
    Read-Host "Pressione Enter para continuar"
}

function Invoke-Option2 {
    <#
    .SYNOPSIS
        Executa a opcao 2
    #>
    Write-Host "Executando opcao 2..." -ForegroundColor Green
    # TODO: Implemente sua logica aqui
    Read-Host "Pressione Enter para continuar"
}

function Invoke-Option3 {
    <#
    .SYNOPSIS
        Executa a opcao 3
    #>
    Write-Host "Executando opcao 3..." -ForegroundColor Green
    # TODO: Implemente sua logica aqui
    Read-Host "Pressione Enter para continuar"
}

# ============================================
# LOOP PRINCIPAL
# ============================================

do {
    Show-Menu
    `$opcao = Read-Host "Escolha uma opcao"
    
    switch (`$opcao) {
        "1" { Invoke-Option1 }
        "2" { Invoke-Option2 }
        "3" { Invoke-Option3 }
        "0" { 
            Write-Host "Saindo..." -ForegroundColor Yellow
            break 
        }
        default { 
            Write-Host "Opcao invalida!" -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
} while (`$opcao -ne "0")

Write-Host "Programa encerrado." -ForegroundColor Cyan
"@

# ============================================
# Conteudo do build.bat
# ============================================
$buildBatContent = @"
@echo off
title $nomeProjeto
powershell.exe -ExecutionPolicy Bypass -File "%~dp0main.ps1"
pause
"@

# ============================================
# Conteudo do .gitignore
# ============================================
$gitignoreContent = @"
# Arquivos de ambiente
.env

# Pasta de assets/recursos
assets/

# Arquivos temporarios do Windows
*.log
*.tmp
~$*

# Cache do PowerShell
*.pssc
*.psm1_disabled
"@

# ============================================
# Conteudo do .env
# ============================================
$envContent = @"
# Arquivos de ambiente
# Configuracoes do servidor
PORT=3000

# SQLITE, MYSQL, POSTGRES
DB_HOST=SQLITE
DB_PORT=
DB_USER=
DB_PASSWORD=
DB_NAME=

# Configuracoes do docker
DB_DOCKER_NAME=
DB_DOCKER_PORT=
DB_DOCKER_USER=
DB_DOCKER_PASSWORD=
DB_DOCKER_DB=
"@

# Cria os arquivos
Write-Host "  -> Criando README.md..." -ForegroundColor White
$readmeContent | Out-File -FilePath (Join-Path $caminhoProjeto "README.md") -Encoding UTF8 -Force

Write-Host "  -> Criando assets..." -ForegroundColor White
New-Item -ItemType Directory -Path (Join-Path $caminhoProjeto "assets") -Force | Out-Null

Write-Host "  -> Criando main.ps1..." -ForegroundColor White
$mainPs1Content | Out-File -FilePath (Join-Path $caminhoProjeto "\assets\main.ps1") -Encoding UTF8 -Force

Write-Host "  -> Criando modules..." -ForegroundColor White
New-Item -ItemType Directory -Path (Join-Path $caminhoProjeto "\assets\modules") -Force | Out-Null

Write-Host "  -> Criando .psm1..." -ForegroundColor White
$psm1Content | Out-File -FilePath (Join-Path $caminhoProjeto "\assets\modules\moduloExample.psm1") -Encoding UTF8 -Force

Write-Host "  -> Criando dist..." -ForegroundColor White
New-Item -ItemType Directory -Path (Join-Path $caminhoProjeto "dist") -Force | Out-Null

Write-Host "  -> Criando teste..." -ForegroundColor White
New-Item -ItemType Directory -Path (Join-Path $caminhoProjeto "test") -Force | Out-Null

Write-Host "  -> Criando build.bat..." -ForegroundColor White
$buildBatContent | Out-File -FilePath (Join-Path $caminhoProjeto "dist\build.bat") -Encoding ASCII -Force

Write-Host "  -> Criando .gitignore..." -ForegroundColor White
$gitignoreContent | Out-File -FilePath (Join-Path $caminhoProjeto ".gitignore") -Encoding UTF8 -Force

Write-Host "  -> Criando .env..." -ForegroundColor White
$envContent | Out-File -FilePath (Join-Path $caminhoProjeto ".env") -Encoding UTF8 -Force

# Mensagem de sucesso
Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "   PROJETO CRIADO COM SUCESSO!          " -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Caminho: $caminhoProjeto" -ForegroundColor Cyan
Write-Host ""
Write-Host "Pastas criadas:" -ForegroundColor White
Write-Host "  - assets" -ForegroundColor Gray
Write-Host "  - dist" -ForegroundColor Gray
Write-Host ""
Write-Host "Arquivos criados:" -ForegroundColor White
Write-Host "  - README.md" -ForegroundColor Gray
Write-Host "  - main.ps1" -ForegroundColor Gray
Write-Host "  - build.bat" -ForegroundColor Gray
Write-Host "  - .gitignore" -ForegroundColor Gray
Write-Host "  - .env" -ForegroundColor Gray
Write-Host ""
Write-Host "Proximos passos:" -ForegroundColor Yellow
Write-Host "  1. Abra o arquivo main.ps1 e comece a codar!" -ForegroundColor White
Write-Host "  2. Execute build.bat para testar seu script" -ForegroundColor White
Write-Host "  3. Atualize o README.md com a documentacao" -ForegroundColor White
Write-Host "  4. Atualize o .env com as configuracoes necessarias" -ForegroundColor White
Write-Host ""

# Pergunta se quer abrir a pasta do projeto
$abrirPasta = Read-Host "Deseja abrir a pasta do projeto? (S/N)"
if ($abrirPasta -eq "S" -or $abrirPasta -eq "s") {
    explorer.exe $caminhoProjeto
}

Write-Host ""
Write-Host "Bom desenvolvimento! :)" -ForegroundColor Cyan
