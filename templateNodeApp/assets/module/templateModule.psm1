# Modulo agregador de templates
# Este modulo importa e re-exporta todos os templates individuais

<#
.SYNOPSIS
Modulo principal para criacao de templates de projeto.

.DESCRIPTION
Este modulo importa todos os templates individuais e fornece uma funcao
conveniente para criar todos os templates de uma vez.

.NOTES
Autor: Joao Henrique
Data: 30/01/2026
Versao: 2.0 - Refatorado em modulos separados
#>

# Obtem o diretorio do modulo atual
if ($PSScriptRoot) {
    $moduleDir = $PSScriptRoot
}
else {
    $moduleDir = Split-Path -Parent ([System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName)
}

# Importa todos os modulos de template
Import-Module "$moduleDir\templates\controllerTemplate.psm1" -Force
Import-Module "$moduleDir\templates\modelTemplate.psm1" -Force
Import-Module "$moduleDir\templates\serviceTemplate.psm1" -Force
Import-Module "$moduleDir\templates\middlewareTemplate.psm1" -Force
Import-Module "$moduleDir\templates\databaseTemplate.psm1" -Force

<#
.SYNOPSIS
Cria todos os templates de projeto de uma vez.

.DESCRIPTION
Esta funcao conveniente cria todos os arquivos de exemplo:
Controller, Model, Service, Middleware e configuracao de banco de dados.

.PARAMETER caminho
O caminho raiz do projeto onde os templates serao criados.

.PARAMETER extensao
A extensao dos arquivos (js ou ts).

.EXAMPLE
New-ProjectTemplates -caminho "C:\meu-projeto" -extensao "ts"

.NOTES
Esta funcao chama individualmente cada funcao de template.
Se desejar criar apenas um tipo especifico, use a funcao correspondente diretamente.
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
        Write-Host "`nTodos os templates criados com sucesso!`n" -ForegroundColor Green
        return $true
    }
    else {
        Write-Host "`n$sucessos de $total templates criados com sucesso.`n" -ForegroundColor Yellow
        return $false
    }
}

# Exporta todas as funcoes (das submodules + a funcao agregadora)
Export-ModuleMember -Function New-ExampleController, New-ExampleModel, New-ExampleService, New-ExampleMiddleware, New-DatabaseConfig, New-ProjectTemplates
