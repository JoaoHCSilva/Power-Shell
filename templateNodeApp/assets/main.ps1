# Configurações de encoding para suportar caracteres especiais (ã, ç, é, etc.)
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

if ($PSScriptRoot) {
    $scriptDir = $PSScriptRoot
}
else {
    $scriptDir = Split-Path -Parent ([System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName)
}

Import-Module "$scriptDir\module\viteInstal.psm1" -Force
Import-Module "$scriptDir\module\adicionarFiles.psm1" -Force
Import-Module "$scriptDir\module\dependenciasModule.psm1" -Force
Import-Module "$scriptDir\module\routesModel.psm1" -Force
Import-Module "$scriptDir\module\templateModule.psm1" -Force
function criarPastas() {
    param(
        [string]$nomeProjeto,
        [string]$caminho
    )
    # iniciando criação do projeto
    $nomeProjeto = Read-Host "Digite o nome do projeto" 
    $caminho = Read-Host "Digite o caminho do projeto"
    Write-Host "Iniciando a criacao de um novo projeto `nNome: $nomeProjeto `nCaminho: $caminho..." -ForegroundColor Green

    if ((Test-path -Path "$caminho\$nomeProjeto")) {
        Write-host "O projeto já existe"
        return 
    }
    # Criar a pasta principal 
    if ((Test-Path -Path $caminho) -and !(Test-path -Path $nomeProjeto)) {
        New-Item -Path $caminho -Name $nomeProjeto -ItemType Directory | Out-Null
    }
    Write-Host "Pastas criadas...`n" -ForegroundColor Yellow
    # Cria as subpastas
    $pastas = @("Controllers", "Models", "Views", "Routes", "Services", "Helpers", "Config", "Database", "Middleware")
    foreach ($pasta in $pastas) {
        New-Item -Path "$caminho\$nomeProjeto" -Name "$pasta" -ItemType Directory | Out-Null 
        Write-Host "- $pasta" -ForegroundColor White
    }


    # Navega para o caminho de instalacao
    Set-Location -Path "$caminho\$nomeProjeto"
    # extensão do projeto
    $extensoes = @("js", "ts")
    $opcoes = [System.Management.Automation.Host.ChoiceDescription[]] @("&JavaScript", "&TypeScript")
    $escolha = $host.UI.PromptForChoice("", "Selecione a linguagem do projeto:", $opcoes, 0)
    Write-Host "O projeto será desenvolvido com base em $($extensoes[$escolha])"
    $extensaoEscolhida = $extensoes[$escolha]
    
    # adiciona app.js ou app.ts
    $nomeArquiApp = "app.$extensaoEscolhida"
    
    # adiciona os arquivos na pasta do projeto
    adicionarFiles -caminho $caminho -nomeProjeto $nomeProjeto -nomeArquiApp $nomeArquiApp -extensao $extensaoEscolhida
    
    # Criando .gitignore
    $gitignoreContent = @"
node_modules/
.env
dist/
build/
*.log
.DS_Store
temp/
coverage/
.vscode/
.idea/
"@
    New-Item -Path "$caminho\$nomeProjeto\.gitignore" -ItemType File -Value $gitignoreContent -Force | Out-Null
    Write-Host "Criado .gitignore" -ForegroundColor Green
    
    # Criando o arquivo router
    routesModel -caminho "Routes" -extensao $extensaoEscolhida
    
    # Criando arquivos de exemplo (templates)
    $caminhoAtual = Get-Location
    New-ProjectTemplates -caminho $caminhoAtual -extensao $extensaoEscolhida
    
    # Pergunta o template que será utilizado
    $templates = @("vanilla", "vanilla-ts", "vue", "vue-ts", "react", "react-ts", "preact", "lit", "svelte", "solid", "qwik")
    $hotkeys = @("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K")
    $opcoesTemplates = for ($i = 0; $i -lt $templates.Count; $i++) {
        New-Object System.Management.Automation.Host.ChoiceDescription ("&$($hotkeys[$i]) $($templates[$i])", $templates[$i])
    }
    $escolha = $host.UI.PromptForChoice("Template", "Selecione o template do projeto:", $opcoesTemplates, 0)
    $templateEscolhido = $templates[$escolha]
    Write-Host "O projeto será desenvolvido com base no template: $($templates[$escolha])" -ForegroundColor Yellow

    # inicia o vite
    instalarVite  $nomeProjeto $templateEscolhido
    Write-Host "Instalado Vite com sucesso!" -ForegroundColor Green
    
    # Adicionar scripts ao package.json
    Write-Host "`nConfigurando scripts do package.json..." -ForegroundColor Cyan
    $packageJsonPath = "package.json"
    if (Test-Path $packageJsonPath) {
        $packageJson = Get-Content $packageJsonPath -Raw | ConvertFrom-Json
        
        # Adicionar scripts úteis
        $packageJson.scripts | Add-Member -MemberType NoteProperty -Name "backend" -Value "nodemon $nomeArquiApp" -Force
        $packageJson.scripts | Add-Member -MemberType NoteProperty -Name "backend:prod" -Value "node $nomeArquiApp" -Force
        $packageJson.scripts | Add-Member -MemberType NoteProperty -Name "start" -Value "concurrently \"npm run dev\" \"npm run backend\"" -Force
        
        # Salvar package.json atualizado
        $packageJson | ConvertTo-Json -Depth 10 | Set-Content $packageJsonPath
        Write-Host "Scripts adicionados ao package.json!" -ForegroundColor Green
    }
    
    # instala as dependecias do projeto
    installDependencies
    # Fim do processo
    Write-Host "Projeto $nomeProjeto criado com sucesso!" -ForegroundColor  Green
    Write-Host "Instrucoes de uso:" -ForegroundColor Yellow
    Write-Host "1. Inicie o projeto: npm run dev" -ForegroundColor White
    Write-Host "2. Configure seu .env, crie uma copia comando=> cp .env.example .env" -ForegroundColor White
    Write-Host "3. Configure seu banco de dados" -ForegroundColor White
    Write-Host "Bom desenvolvimento :) " -ForegroundColor Green
    Read-Host "Pressione Enter para sair"
}

criarPastas
