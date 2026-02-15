# ============================================
# limpezaCompleta
# ============================================
# Descricao: [Descreva o objetivo do script]
# Autor: [Seu Nome]
# Data: 04/02/2026
# ============================================

# Configuracoes iniciais
$ErrorActionPreference = "Stop"

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
    Write-Host "   limpezaCompleta                          " -ForegroundColor Cyan
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
    $opcao = Read-Host "Escolha uma opcao"
    
    switch ($opcao) {
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
} while ($opcao -ne "0")

Write-Host "Programa encerrado." -ForegroundColor Cyan
