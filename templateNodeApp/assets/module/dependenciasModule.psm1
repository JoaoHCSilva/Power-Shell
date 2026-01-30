# instala as dependecias do projeto
function installDependencies {
    param(
        [string]$path
    )
    Write-Host "Instalando dependecias..." -ForegroundColor white
    
    # Dependências de produção
    $depProducao = @("express", "dotenv")
    
    # Dependências de desenvolvimento
    $depDesenvolvimento = @("nodemon", "ts-node", "typescript", "@types/express", "@types/node")
    
    Write-Host "Instalando dependencias de producao..." -ForegroundColor Yellow
    npm install @depProducao -d
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Erro ao instalar dependências de producao!" -ForegroundColor Red
        return
    }
    
    Write-Host "Instalando dependencias de desenvolvimento..." -ForegroundColor Yellow
    npm install --save-dev @depDesenvolvimento
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Erro ao instalar dependências de desenvolvimento!" -ForegroundColor Red
        return
    }
    
    Write-Host "Dependecias instaladas com sucesso!" -ForegroundColor green
    return
}

Export-ModuleMember -Function installDependencies  