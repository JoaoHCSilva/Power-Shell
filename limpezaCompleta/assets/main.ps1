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

function limpezaCompleta {

    # Remove arquivos temporários do usuário
    Remove-Item -Path "$env:LOCALAPPDATA\Temp\*" -Recurse -Force

    # Remove arquivos temporários do sistema
    Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force

    # Limpar cache do Windows Update
    Stop-Service -Name wuauserv
    Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force
    Start-Service -Name wuauserv

    # Limpar cache do navegador Edge
    Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache\*" -Recurse -Force

    Write-Output "Limpeza de disco concluída com sucesso."
}

limpezaCompleta
