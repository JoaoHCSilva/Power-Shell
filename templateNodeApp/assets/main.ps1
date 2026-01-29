# Configurações de encoding para suportar caracteres especiais (ã, ç, é, etc.)
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
chcp 65001 | Out-Null
Import-Module "$PSScriptRoot\adicionarFiles.psm1" -Force
function criarPastas() {
    param(
        [string]$nomeProjeto,
        [string]$caminho
    )
    # iniciando criação do projeto
    $nomeProjeto = Read-Host "Digite o nome do projeto" 
    $caminho = Read-Host "Digite o caminho do projeto"
    Write-Host "Iniciando a criacao de um novo projeto `nNome: $nomeProjeto `nCaminho: $caminho..." -ForegroundColor Green

    if ((Test-path -Path $nomeProjeto)) {
        Write-host "O projeto já existe"
        return 
    }
    # Criar a pasta principal 
    if ((Test-Path -Path $caminho) -and !(Test-path -Path $nomeProjeto)) {
        New-Item -Path $caminho -Name $nomeProjeto -ItemType Directory | Out-Null
    }
    # Cria as subpastas
    $pastas = @("Controllers", "Models", "Views", "Routes", "Services", "Helpers", "Public", "Config", "Database", "Middleware")
    foreach ($pasta in $pastas) {
        New-Item -Path "$caminho\$nomeProjeto" -Name "$pasta" -ItemType Directory | Out-Null 
    }
    # extensão do projeto
    $extensoes = @("js", "ts")
    $opcoes = [System.Management.Automation.Host.ChoiceDescription[]] @("&JavaScript", "&TypeScript")
    $escolha = $host.UI.PromptForChoice("Extensão", "Selecione a linguagem do projeto:", $opcoes, 0)
    Write-Host "O projeto será desenvolvido com base em $($extensoes[$escolha])"
    $extensaoEscolhida = $extensoes[$escolha]
    # adiciona app.js ou app.ts
    $nomeArquiApp = "app.$extensaoEscolhida"
    adicionarFiles -caminho $caminho -nomeProjeto $nomeProjeto -nomeArquiApp $nomeArquiApp
    # Fim do processo
    Write-Host "Projeto: $nomeProjeto criado com sucesso!" -ForegroundColor  Green
}

criarPastas
