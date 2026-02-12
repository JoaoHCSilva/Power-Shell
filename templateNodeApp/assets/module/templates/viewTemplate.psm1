# adiciona as pastas js, css e layout dentro de views/
function viewTemplate {
    param (
        [string]$caminho
    )
    Write-Host "Adicionando as pastas js, css e layout dentro de views... `n" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path "$caminho/views/js" -Force
    New-Item -ItemType Directory -Path "$caminho/views/css" -Force
    New-Item -ItemType Directory -Path "$caminho/views/layout" -Force
    Write-Host "Pastas adicionadas com sucesso!" -ForegroundColor Green
    
}

Export-ModuleMember -Function viewTemplate
