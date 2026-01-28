Import-Module "$PSScriptRoot\arquivosPadrao.psm1" -Force -ErrorAction Stop
# criar padrao de pojetos em ps1, cria todas as pastas e arquivos iniciais
function criarPadraoProjeto () {
    [CmdletBinding()]
    param (
        [string]$nomeProjeto,
        [string]$caminhoProjeto
    )

    $nomeProjeto = Read-Host "Digite o nome do projeto"
    $caminhoProjeto = Read-Host "Digite o caminho do projeto"

    # criar pasta do projeto
    if (Test-Path -Path "$caminhoProjeto\$nomeProjeto") {
        Write-Host "A pasta $nomeProjeto ja existe!`n" -ForegroundColor Red
        return
    }
    else {
        New-Item -ItemType Directory -Path "$caminhoProjeto\$nomeProjeto" -Force
        Write-Host "Pasta $nomeProjeto criada com sucesso!`n" -ForegroundColor Green
    }

    # Pastas que são padrão em qualquer projeto
    $pastasPadrao = @("assets", "dist", "test")
    # Criar pastas do projeto
    try {
        foreach ($pasta in $pastasPadrao) {
            New-Item -ItemType Directory -Path "$caminhoProjeto\$nomeProjeto\$pasta" -Force
        }
        Write-Host "Pastas padrão criadas com sucesso!`n" -ForegroundColor Green
    }
    catch {
        Write-Host "Erro ao criar pastas do projeto!`n" -ForegroundColor Red
    }

    # criar arquivos iniciais
    try {
        New-Item -ItemType File -Path "$nomeProjeto\README.md" -Force
        New-Item -ItemType File -Path "$nomeProjeto\assets\main.ps1" -Force #salva dentro da pasta assets
        New-Item -ItemType File -Path "$nomeProjeto\.gitignore" -Force
        New-Item -ItemType File -Path "$nomeProjeto\build.ps1" -Force
        Write-Host "Arquivos iniciais criados com sucesso!`n" -ForegroundColor Green
    }
    catch {
        Write-Host "Erro ao criar arquivos iniciais!`n" -ForegroundColor Red
    }

    # adicionar os arqquivos
    try {
        criarArquivosPadrao -nomeProjeto $nomeProjeto
    }
    catch {
        Write-Host "Erro ao adicionar os arquivos!`n" -ForegroundColor Red
    }
}

# Executar a função principal
criarPadraoProjeto