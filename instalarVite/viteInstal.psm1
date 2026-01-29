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
        [string]$caminho,
        [string]$nomeDoProjeto,
        [string]$template = "vanilla"  # Opções: vanilla, vue, react, preact, lit, svelte, solid, qwik
    )

    Write-Host "Instalando o Vite com a ultima versão . . ." -ForegroundColor white
    
    # inicia o projeto com template especificado (sem interação)
    npm create vite@latest $nomeDoProjeto -- --template $template
    
    # navega para o diretório do projeto
    Set-Location $nomeDoProjeto
    
    # instala as dependencias
    npm install
}

Export-ModuleMember -Function instalarVite