# Módulo agregador de templates
# Este módulo importa e re-exporta todos os templates individuais

<#
.SYNOPSIS
Módulo principal para criação de templates de projeto.

.DESCRIPTION
Este módulo importa todos os templates individuais e fornece uma função
conveniente para criar todos os templates de uma vez.

.NOTES
Autor: João Henrique
Data: 30/01/2026
Versão: 2.0 - Refatorado em módulos separados
#>

# Obtém o diretório do módulo atual
if ($PSScriptRoot) {
    $moduleDir = $PSScriptRoot
}
else {
    $moduleDir = Split-Path -Parent ([System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName)
}

# Importa todos os módulos de template
Import-Module "$moduleDir\templates\controllerTemplate.psm1" -Force
Import-Module "$moduleDir\templates\modelTemplate.psm1" -Force
Import-Module "$moduleDir\templates\serviceTemplate.psm1" -Force
Import-Module "$moduleDir\templates\middlewareTemplate.psm1" -Force
Import-Module "$moduleDir\templates\databaseTemplate.psm1" -Force

<#
.SYNOPSIS
Cria todos os templates de projeto de uma vez.

.DESCRIPTION
Esta função conveniente cria todos os arquivos de exemplo:
Controller, Model, Service, Middleware e configuração de banco de dados.

.PARAMETER caminho
O caminho raiz do projeto onde os templates serão criados.

.PARAMETER extensao
A extensão dos arquivos (js ou ts).

.EXAMPLE
New-ProjectTemplates -caminho "C:\meu-projeto" -extensao "ts"

.NOTES
Esta função chama individualmente cada função de template.
Se desejar criar apenas um tipo específico, use a função correspondente diretamente.
#>
function New-ProjectTemplates {
    param(
        [Parameter(Mandatory = $true)]
        [string]$caminho,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("js", "ts")]
        [string]$extensao = "js"
    )
    
    Write-Host "`nCriando arquivos de exemplo..." -ForegroundColor Cyan
    
    # Contador de sucesso
    $sucessos = 0
    $total = 5
    
    # Cria cada template
    if (New-ExampleController -caminho $caminho -extensao $extensao) { $sucessos++ }
    if (New-ExampleModel -caminho $caminho -extensao $extensao) { $sucessos++ }
    if (New-ExampleService -caminho $caminho -extensao $extensao) { $sucessos++ }
    if (New-ExampleMiddleware -caminho $caminho -extensao $extensao) { $sucessos++ }
    if (New-DatabaseConfig -caminho $caminho -extensao $extensao) { $sucessos++ }
    
    # Mensagem final
    if ($sucessos -eq $total) {
        Write-Host "`n✓ Todos os templates criados com sucesso!`n" -ForegroundColor Green
        return $true
    }
    else {
        Write-Host "`n⚠ $sucessos de $total templates criados com sucesso.`n" -ForegroundColor Yellow
        return $false
    }
}

# Exporta todas as funções (das submodules + a função agregadora)
Export-ModuleMember -Function New-ExampleController, New-ExampleModel, New-ExampleService, New-ExampleMiddleware, New-DatabaseConfig, New-ProjectTemplates
