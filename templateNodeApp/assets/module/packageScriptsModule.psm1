<#
.SYNOPSIS
Adiciona scripts personalizados ao package.json para desenvolvimento full-stack.

.DESCRIPTION
Este módulo atualiza o package.json gerado pelo Vite para incluir scripts
adicionais para executar o backend Node.js/Express.

.PARAMETER caminho
O caminho raiz do projeto onde o package.json está localizado.

.PARAMETER extensao
A extensão do arquivo principal (js ou ts).

.EXAMPLE
Add-BackendScripts -caminho "C:\meu-projeto" -extensao "ts"

.NOTES
Autor: João Henrique
Data: 02/02/2026
#>

function Add-BackendScripts {
    param(
        [Parameter(Mandatory = $true)]
        [string]$caminho,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("js", "ts")]
        [string]$extensao = "js"
    )
    
    $packageJsonPath = Join-Path $caminho "package.json"
    
    if (-not (Test-Path $packageJsonPath)) {
        Write-Host "  [ERRO] package.json não encontrado em: $packageJsonPath" -ForegroundColor Red
        return $false
    }
    
    try {
        # Lê o package.json
        $packageJson = Get-Content $packageJsonPath -Raw | ConvertFrom-Json
        
        # Define os scripts baseados na extensão
        if ($extensao -eq "ts") {
            $serverScript = "ts-node app.ts"
            $devBackendScript = "nodemon --exec ts-node app.ts"
        } else {
            $serverScript = "node app.js"
            $devBackendScript = "nodemon app.js"
        }
        
        # Adiciona ou atualiza scripts
        if (-not $packageJson.scripts) {
            $packageJson | Add-Member -MemberType NoteProperty -Name "scripts" -Value @{}
        }
        
        # Preserva scripts existentes do Vite e adiciona novos
        $packageJson.scripts | Add-Member -MemberType NoteProperty -Name "server" -Value $serverScript -Force
        $packageJson.scripts | Add-Member -MemberType NoteProperty -Name "dev:backend" -Value $devBackendScript -Force
        $packageJson.scripts | Add-Member -MemberType NoteProperty -Name "dev:frontend" -Value ($packageJson.scripts.dev ?? "vite") -Force
        
        # Script para rodar frontend e backend simultaneamente (requer concurrently)
        $packageJson.scripts | Add-Member -MemberType NoteProperty -Name "dev:fullstack" -Value "concurrently `"npm run dev:backend`" `"npm run dev:frontend`"" -Force
        $packageJson.scripts | Add-Member -MemberType NoteProperty -Name "start" -Value $serverScript -Force
        
        # Salva o package.json atualizado com indentação
        $packageJson | ConvertTo-Json -Depth 10 | Set-Content $packageJsonPath -Encoding UTF8
        
        Write-Host "  [OK] Scripts adicionados ao package.json:" -ForegroundColor Green
        Write-Host "    - server: $serverScript" -ForegroundColor Gray
        Write-Host "    - dev:backend: $devBackendScript" -ForegroundColor Gray
        Write-Host "    - dev:frontend: preservado do Vite" -ForegroundColor Gray
        Write-Host "    - dev:fullstack: executa frontend + backend simultaneamente" -ForegroundColor Gray
        Write-Host "    - start: $serverScript" -ForegroundColor Gray
        
        return $true
    }
    catch {
        Write-Host "  [ERRO] Falha ao atualizar package.json: $_" -ForegroundColor Red
        return $false
    }
}

Export-ModuleMember -Function Add-BackendScripts
