# processo para buildar uma aplicacao ps1 em exe

# Importa o modulo ps2exe (necessario para usar Invoke-PS2EXE)
Import-Module ps2exe -ErrorAction SilentlyContinue

# Verifica se o modulo foi carregado
if (!(Get-Module -Name ps2exe)) {
    Write-Host "Modulo ps2exe nao encontrado. Instalando..." -ForegroundColor Yellow
    Install-Module -Name ps2exe -Scope CurrentUser -Force
    Import-Module ps2exe
}

function build-ps2exe {
    param (
        [string]$InputFile,
        [string]$OutputFile
    )
    
    Write-Host "Iniciando o processo de build..." -ForegroundColor Green

    # Validacao do arquivo de ENTRADA (deve existir)
    if (!(Test-Path $InputFile)) {
        Write-Host "ERRO: Arquivo de entrada nao encontrado: $InputFile" -ForegroundColor Red
        return
    }

    # Validacao do arquivo de SAIDA (a PASTA deve existir, o arquivo sera criado)
    $pastaOutput = Split-Path -Parent $OutputFile
    if (!(Test-Path $pastaOutput)) {
        Write-Host "Criando pasta de saida: $pastaOutput" -ForegroundColor Yellow
        New-Item -ItemType Directory -Path $pastaOutput -Force | Out-Null
    }

    # Se o arquivo de saida ja existe, pergunta se quer sobrescrever
    if (Test-Path $OutputFile) {
        $resposta = Read-Host "O arquivo $OutputFile ja existe. Sobrescrever? (S/N)"
        if ($resposta -ne "S" -and $resposta -ne "s") {
            Write-Host "Operacao cancelada pelo usuario." -ForegroundColor Yellow
            return
        }
        Remove-Item $OutputFile -Force
    }

    # Parametros para o PS2EXE
    $params = @{
        InputFile  = $InputFile
        OutputFile = $OutputFile
    }

    try {
        Invoke-PS2EXE @params
        Write-Host "Build concluido com sucesso!" -ForegroundColor Green
        Write-Host "Arquivo gerado: $OutputFile" -ForegroundColor Cyan
    }
    catch {
        Write-Host "Erro durante o build: $_" -ForegroundColor Red
    }
}

$InputFile = Read-Host "Digite o caminho do arquivo de entrada (.ps1)"
$OutputFile = Read-Host "Digite o caminho do arquivo de saida (.exe)"

build-ps2exe -InputFile $InputFile -OutputFile $OutputFile
