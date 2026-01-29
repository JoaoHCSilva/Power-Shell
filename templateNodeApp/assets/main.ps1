# Configurações de encoding para suportar caracteres especiais (ã, ç, é, etc.)
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
Import-Module "$PSScriptRoot\module\viteInstal.psm1" -Force
Import-Module "$PSScriptRoot\module\adicionarFiles.psm1" -Force
Import-Module "$PSScriptRoot\module\routesModel.psm1" -Force
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
    $pastas = @("Controllers", "Models", "Views", "Routes", "Services", "Helpers", "Config", "Database", "Middleware")
    foreach ($pasta in $pastas) {
        New-Item -Path "$caminho\$nomeProjeto" -Name "$pasta" -ItemType Directory | Out-Null 
        Write-Host "Criando a pasta $pasta...`n" -ForegroundColor White
    }


    # Navega para o caminho de instalacao
    Set-Location -Path "$caminho\$nomeProjeto"
    # extensão do projeto
    $extensoes = @("js", "ts")
    $opcoes = [System.Management.Automation.Host.ChoiceDescription[]] @("&JavaScript", "&TypeScript")
    $escolha = $host.UI.PromptForChoice("Selecione a linguagem do projeto:", $opcoes, 0)
    Write-Host "O projeto será desenvolvido com base em $($extensoes[$escolha])"
    $extensaoEscolhida = $extensoes[$escolha]
    
    # adiciona app.js ou app.ts
    $nomeArquiApp = "app.$extensaoEscolhida"
    
    # adiciona os arquivos na pasta do projeto
    adicionarFiles -caminho $caminho -nomeProjeto $nomeProjeto -nomeArquiApp $nomeArquiApp
    # Criando o arquivo router
    routesModel -caminho "\$nomeProjeto\Routes" -extensao $extensaoEscolhida
    # Pergunta o template que será utilizado
    $templates = @("vanilla", "vanilla-ts", "vue", "vue-ts", "react", "react-ts", "preact", "lit", "svelte", "solid", "qwik")
    $opcoesTemplates = for ($i = 0; $i -lt $templates.Count; $i++) {
        New-Object System.Management.Automation.Host.ChoiceDescription ("&$($i + 1) $($templates[$i])", $templates[$i])
    }
    $escolha = $host.UI.PromptForChoice("Template", "Selecione o template do projeto:", $opcoesTemplates, 0)
    $templateEscolhido = $templates[$escolha]
    Write-Host "O projeto será desenvolvido com base em $($templates[$escolha])" -ForegroundColor Yellow

    # nageva para a pasta do projeto
    # Navega para o caminho de instalacao
    Set-Location -Path "$caminho\$nomeProjeto"
    # inicia o vite
    instalarVite  $nomeProjeto $templateEscolhido
    Write-Host "Intalado Vite com sucesso!`n" -ForegroundColor Green
    # Fim do processo
    Write-Host "Projeto: $nomeProjeto criado com sucesso!" -ForegroundColor  Green
}

criarPastas
