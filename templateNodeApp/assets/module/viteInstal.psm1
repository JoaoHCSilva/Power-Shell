# Instalação do Vite com a ultima versão

<#
.SYNOPSIS
Instala o Vite com a ultima versão.

.DESCRIPTION
Esta função instala o Vite com a ultima versão.

.PARAMETER caminho
O caminho para o diretório onde o projeto será instalado.

.PARAMETER nomeDoProjeto
O nome do projeto.

.PARAMETER template
O template a ser usado no projeto. Opções: vanilla, vue, react, preact, lit, svelte, solid, qwik

.EXAMPLE
InstalarVite -caminho (Get-Location) -nomeDoProjeto "testeVite" -template "react-ts"

.NOTES
Autor: João Henrique
Data: 28/01/2026
#>
function instalarVite {
    param(
        [string]$nomeDoProjeto,
        [string]$template = "vanilla"  # Opções: vanilla, vue, react, preact, lit, svelte, solid, qwik
    )

    Write-Host "Iniciando a instalacao do Vite com a ultima versão..." -ForegroundColor white

    # Cria uma pasta temporaria dentro do projeto
    $pastaTemporaria = "temp"
    New-Item -ItemType Directory -Path $pastaTemporaria | Out-Null
    # navega para o diretório dos arquivos temporarios
    Set-Location $pastaTemporaria
    # inicia o projeto com template especificado (sem interação)
    npm create vite@latest $nomeDoProjeto -y -- --template $template --no-interactive

    $origem = ".\$nomeDoProjeto"
    $destino = "..\"

    Write-Host "Movendo os arquivos para a pasta do projeto..." -ForegroundColor Yellow
    # move todos os arquivos da pasta temporaria para a pasta do projeto
    Get-ChildItem -Path $origem -Force | Move-Item -Destination $destino -Force
    Write-Host "Arquivos movidos com sucesso!" -ForegroundColor White
    # volta para a pasta do projeto
    Set-Location ".."
    Write-Host "Voltando para a pasta do projeto..." -ForegroundColor White
    # remove a pasta temporaria completamente
    Remove-Item -Path $pastaTemporaria -Recurse -Force
    Write-Host "Pasta temporária removida!" -ForegroundColor Green
}

Export-ModuleMember -Function instalarVite