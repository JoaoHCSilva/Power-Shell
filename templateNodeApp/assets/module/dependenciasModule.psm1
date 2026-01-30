# instala as dependecias do projeto
function installDependencies {
    param(
        [string]$path
    )
    Write-Host "Instalando dependecias..." -ForegroundColor white
    $dependencias = @(
        "express",
        "dotenv",
        "nodemon",
        "ts-node",
        "typescript",
        "@types/express",
        "@types/node"
    )
    $dependencias | ForEach-Object {
        npm install $_ 
    }
    Write-Host "Dependecias instaladas com sucesso!" -ForegroundColor green
}

Export-ModuleMember -Function installDependencies  