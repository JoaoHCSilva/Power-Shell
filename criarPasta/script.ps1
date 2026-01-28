# Configurações de encoding para suportar caracteres especiais (ã, ç, é, etc.)
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
chcp 65001 | Out-Null
function criarPastas() {
    param(
        [Parameter(Mandatory = $true)]
        [string]$nomeProjeto,
        [string]$caminho
    )
    # iniciando criação do projeto
    Write-Host "Iniciando a criacao de um novo projeto `nNome: $nomeProjeto `nCaminho: $caminho..." -ForegroundColor Green
    # Criar a pasta principal
    New-Item -Path $caminho -Name $nomeProjeto -ItemType Directory | Out-Null
    # Cria as subpastas
    $pastas = @("Controllers", "Models", "Views", "Routes", "Services", "Helpers", "Public", "Config", "Database", "Middleware")
    foreach ($pasta in $pastas) {
        New-Item -Path "$caminho\$nomeProjeto" -Name "$pasta" -ItemType Directory | Out-Null 
    }
    # extensão do projeto
    Write-Host "Qual a extencao do projeto?"
    $extensoes = @("js", "ts")
    $nomeExtensoes = @("JavaScript", "TypeScript")
    for ($i = 0; $i -lt $nomeExtensoes.Length; $i++) {
        $cor = if ($nomeExtensoes[$i] -eq "JavaScript") { "Yellow" } else { "Cyan" }
        Write-Host "[$i] $($nomeExtensoes[$i])" -ForegroundColor $cor
    }
    $escolha = $null
    while ($null -eq $escolha -or $escolha -lt 0 -or $escolha -ge $extensoes.Length) {
        $escolha = Read-Host "Digite o numero da extencao"
        $escolha = [int]$escolha
    }
    $extensaoEscolhida = $extensoes[$escolha]
    # adiciona app.js ou app.ts
    New-Item -Path "$caminho\$nomeProjeto" -Name "app.$extensaoEscolhida" -ItemType File | Out-Null

    # Fim do processo
    Write-Host "Projeto: $nomeProjeto criado com sucesso!" -ForegroundColor  Green
}

criarPastas -nomeProjeto "ProjetoTeste" -caminho "C:\Users\joaohenrique\POWERSHELL\criarPastas"

