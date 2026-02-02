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
Import-Module "$scriptDir\module\packageScriptsModule.psm1" -Force

function Test-Prerequisites {
    Write-Host "Verificando pré-requisitos..." -ForegroundColor Cyan
    
    # Verifica se Node.js está instalado
    $nodeCmd = Get-Command node -ErrorAction SilentlyContinue
    if (-not $nodeCmd) {
        Write-Host "[ERRO] Node.js não está instalado. Por favor, instale Node.js primeiro." -ForegroundColor Red
        Write-Host "Download: https://nodejs.org/" -ForegroundColor Yellow
        return $false
    }
    
    # Verifica versão do Node.js (mínimo 16.0.0)
    $nodeVersion = (node --version) -replace 'v', ''
    $minVersion = [version]"16.0.0"
    $currentVersion = [version]$nodeVersion
    
    if ($currentVersion -lt $minVersion) {
        Write-Host "[ERRO] Node.js versão $nodeVersion detectada. Versão mínima requerida: 16.0.0" -ForegroundColor Red
        return $false
    }
    Write-Host "  [OK] Node.js v$nodeVersion" -ForegroundColor Green
    
    # Verifica se npm está instalado
    $npmCmd = Get-Command npm -ErrorAction SilentlyContinue
    if (-not $npmCmd) {
        Write-Host "[ERRO] npm não está instalado ou não está no PATH." -ForegroundColor Red
        return $false
    }
    
    $npmVersion = npm --version
    Write-Host "  [OK] npm v$npmVersion" -ForegroundColor Green
    
    Write-Host "Todos os pré-requisitos satisfeitos!" -ForegroundColor Green
    return $true
}

function Remove-ProjectOnError {
    param([string]$path)
    
    if (Test-Path $path) {
        Write-Host "`n[ROLLBACK] Removendo projeto incompleto..." -ForegroundColor Yellow
        try {
            Remove-Item -Path $path -Recurse -Force -ErrorAction Stop
            Write-Host "[OK] Projeto removido com sucesso." -ForegroundColor Green
        } catch {
            Write-Host "[AVISO] Não foi possível remover automaticamente: $path" -ForegroundColor Yellow
            Write-Host "Por favor, remova manualmente." -ForegroundColor Yellow
        }
    }
}

function Test-ProjectName {
    param([string]$name)
    
    # Valida caracteres inválidos para nomes de pasta/npm
    if ($name -match '[<>:"/\|?*]') {
        Write-Host "[ERRO] Nome do projeto contém caracteres inválidos." -ForegroundColor Red
        Write-Host "Evite usar: < > : " / \ | ? *" -ForegroundColor Yellow
        return $false
    }
    
    if ($name.Trim() -eq "") {
        Write-Host "[ERRO] Nome do projeto não pode ser vazio." -ForegroundColor Red
        return $false
    }
    
    # Verifica espaços (NPM não recomenda)
    if ($name -match '\s') {
        Write-Host "[AVISO] Nome do projeto contém espaços. Recomenda-se usar hífens ou underscores." -ForegroundColor Yellow
        $resposta = Read-Host "Continuar mesmo assim? (S/N)"
        if ($resposta -ne 'S' -and $resposta -ne 's') {
            return $false
        }
    }
    
    return $true
}

function criarPastas() {
    param(
        [string]$nomeProjeto,
        [string]$caminho
    )
    
    # Verifica pré-requisitos
    if (-not (Test-Prerequisites)) {
        Read-Host "Pressione Enter para sair"
        return
    }
    
    # iniciando criação do projeto
    do {
        $nomeProjeto = Read-Host "Digite o nome do projeto"
    } while (-not (Test-ProjectName -name $nomeProjeto))
    
    $caminho = Read-Host "Digite o caminho do projeto"
    
    # Validação do caminho
    if (-not (Test-Path -Path $caminho)) {
        Write-Host "[ERRO] O caminho especificado não existe: $caminho" -ForegroundColor Red
        $criar = Read-Host "Deseja criar este caminho? (S/N)"
        if ($criar -eq 'S' -or $criar -eq 's') {
            try {
                New-Item -Path $caminho -ItemType Directory -Force | Out-Null
                Write-Host "[OK] Caminho criado com sucesso!" -ForegroundColor Green
            } catch {
                Write-Host "[ERRO] Não foi possível criar o caminho: $_" -ForegroundColor Red
                Read-Host "Pressione Enter para sair"
                return
            }
        } else {
            Write-Host "Operação cancelada pelo usuário." -ForegroundColor Yellow
            Read-Host "Pressione Enter para sair"
            return
        }
    }
    
    Write-Host "Iniciando a criacao de um novo projeto `nNome: $nomeProjeto `nCaminho: $caminho..." -ForegroundColor Green

    $caminhoCompleto = Join-Path $caminho $nomeProjeto
    
    if (Test-Path -Path $caminhoCompleto) {
        Write-Host "[ERRO] O projeto já existe em: $caminhoCompleto" -ForegroundColor Red
        Read-Host "Pressione Enter para sair"
        return 
    }
    
    # Criar a pasta principal com tratamento de erro
    try {
        New-Item -Path $caminho -Name $nomeProjeto -ItemType Directory -ErrorAction Stop | Out-Null
        Write-Host "Projeto criado em: $caminhoCompleto" -ForegroundColor Green
    } catch {
        Write-Host "[ERRO] Falha ao criar pasta do projeto: $_" -ForegroundColor Red
        Read-Host "Pressione Enter para sair"
        return
    }
    Write-Host "Pastas criadas...`n" -ForegroundColor Yellow
    # Cria as subpastas
    $pastas = @("Controllers", "Models", "Views", "Routes", "Services", "Helpers", "Config", "Database", "Middleware")
    try {
        foreach ($pasta in $pastas) {
            New-Item -Path "$caminho\$nomeProjeto" -Name "$pasta" -ItemType Directory -ErrorAction Stop | Out-Null 
            Write-Host "- $pasta" -ForegroundColor White
        }
    } catch {
        Write-Host "[ERRO] Falha ao criar subpastas: $_" -ForegroundColor Red
        Remove-ProjectOnError -path $caminhoCompleto
        Read-Host "Pressione Enter para sair"
        return
    }


    # Navega para o caminho de instalacao
    try {
        Set-Location -Path "$caminho\$nomeProjeto" -ErrorAction Stop
    } catch {
        Write-Host "[ERRO] Não foi possível navegar para o diretório do projeto: $_" -ForegroundColor Red
        Remove-ProjectOnError -path $caminhoCompleto
        Read-Host "Pressione Enter para sair"
        return
    }
    # extensão do projeto
    $extensoes = @("js", "ts")
    $opcoes = [System.Management.Automation.Host.ChoiceDescription[]] @("&JavaScript", "&TypeScript")
    $escolha = $host.UI.PromptForChoice("", "Selecione a linguagem do projeto:", $opcoes, 0)
    Write-Host "O projeto será desenvolvido com base em $($extensoes[$escolha])"
    $extensaoEscolhida = $extensoes[$escolha]
    
    # adiciona app.js ou app.ts
    $nomeArquiApp = "app.$extensaoEscolhida"
    
    # adiciona os arquivos na pasta do projeto
    try {
        adicionarFiles -caminho $caminho -nomeProjeto $nomeProjeto -nomeArquiApp $nomeArquiApp -extensao $extensaoEscolhida
    } catch {
        Write-Host "[ERRO] Falha ao criar arquivos principais: $_" -ForegroundColor Red
        Set-Location $caminho
        Remove-ProjectOnError -path $caminhoCompleto
        Read-Host "Pressione Enter para sair"
        return
    }
    
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
    Write-Host "`nCriando templates no caminho: $caminhoAtual" -ForegroundColor Cyan
    Write-Host "Verificando pastas existentes..." -ForegroundColor Gray
    Get-ChildItem -Directory | Select-Object -ExpandProperty Name | ForEach-Object { Write-Host "  - $_" -ForegroundColor Gray }
    
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
    try {
        instalarVite $nomeProjeto $templateEscolhido
        Write-Host "Instalado Vite com sucesso!" -ForegroundColor Green
    } catch {
        Write-Host "[ERRO] Falha ao instalar Vite: $_" -ForegroundColor Red
        Set-Location $caminho
        Remove-ProjectOnError -path $caminhoCompleto
        Read-Host "Pressione Enter para sair"
        return
    }
    
    # instala as dependecias do projeto
    try {
        installDependencies
    } catch {
        Write-Host "[ERRO] Falha ao instalar dependências: $_" -ForegroundColor Red
        Write-Host "[INFO] Você pode instalar manualmente com: npm install" -ForegroundColor Yellow
    }
    
    # Adiciona scripts do backend ao package.json
    try {
        Write-Host "`nConfigurando scripts do package.json..." -ForegroundColor Cyan
        Add-BackendScripts -caminho (Get-Location) -extensao $extensaoEscolhida
    } catch {
        Write-Host "[AVISO] Não foi possível configurar scripts automaticamente: $_" -ForegroundColor Yellow
    }
    
    # Fim do processo
    Write-Host "`n========================================" -ForegroundColor Green
    Write-Host "  Projeto $nomeProjeto criado com sucesso!" -ForegroundColor  Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "`nResumo da instalação:" -ForegroundColor Cyan
    Write-Host "  Localização: $caminhoCompleto" -ForegroundColor White
    Write-Host "  Linguagem: $extensaoEscolhida" -ForegroundColor White
    Write-Host "  Frontend: Vite ($templateEscolhido)" -ForegroundColor White
    Write-Host "  Backend: Express + Node.js" -ForegroundColor White
    Write-Host "  CORS: Configurado" -ForegroundColor White
    Write-Host "  Rate Limiting: Ativo (100 req/15min)" -ForegroundColor White
    Write-Host "  Logging: Winston" -ForegroundColor White
    Write-Host "  Autenticação: JWT" -ForegroundColor White
    Write-Host "  Validação: express-validator" -ForegroundColor White
    Write-Host "  Docker: Configurado" -ForegroundColor White
    
    Write-Host "`nPróximos passos:" -ForegroundColor Yellow
    Write-Host "  1. Entre no diretório:" -ForegroundColor White
    Write-Host "     cd `"$caminhoCompleto`"" -ForegroundColor Gray
    Write-Host "`n  2. Configure variáveis de ambiente (.env):" -ForegroundColor White
    Write-Host "     - Arquivo .env já foi criado automaticamente" -ForegroundColor Gray
    Write-Host "     - Edite conforme necessário (porta, CORS, banco de dados)" -ForegroundColor Gray
    Write-Host "     - IMPORTANTE: Altere JWT_SECRET em produção!" -ForegroundColor Yellow
    Write-Host "`n  3. Inicie o desenvolvimento:" -ForegroundColor White
    Write-Host "     Frontend apenas:  npm run dev" -ForegroundColor Gray
    Write-Host "     Backend apenas:   npm run dev:backend" -ForegroundColor Gray
    Write-Host "     Full-stack:       npm run dev:fullstack" -ForegroundColor Gray
    Write-Host "     Docker:           docker-compose up" -ForegroundColor Gray
    Write-Host "`n  4. Acesse a aplicação:" -ForegroundColor White
    Write-Host "     Frontend: http://localhost:5173" -ForegroundColor Gray
    Write-Host "     Backend:  http://localhost:3000" -ForegroundColor Gray
    Write-Host "`n  5. Estrutura criada:" -ForegroundColor White
    Write-Host "     BACKEND:" -ForegroundColor Cyan
    Write-Host "     - Controllers/UserController.$extensaoEscolhida (conectado ao Service)" -ForegroundColor Gray
    Write-Host "     - Controllers/AuthController.$extensaoEscolhida (login/registro JWT)" -ForegroundColor Gray
    Write-Host "     - Services/UserService.$extensaoEscolhida (lógica de negócio)" -ForegroundColor Gray
    Write-Host "     - Models/User.$extensaoEscolhida (modelo de dados)" -ForegroundColor Gray
    Write-Host "     - Routes/router.$extensaoEscolhida (rotas REST)" -ForegroundColor Gray
    Write-Host "     - Middleware/middlewares.$extensaoEscolhida (4 exemplos)" -ForegroundColor Gray
    Write-Host "     - Helpers/validation.$extensaoEscolhida (express-validator)" -ForegroundColor Gray
    Write-Host "     CONFIGURAÇÃO:" -ForegroundColor Cyan
    Write-Host "     - Config/database.$extensaoEscolhida (configuração DB)" -ForegroundColor Gray
    Write-Host "     - Config/logger.$extensaoEscolhida (Winston logging)" -ForegroundColor Gray
    Write-Host "     - Dockerfile, docker-compose.yml (containerização)" -ForegroundColor Gray
    Write-Host "     - logs/ (pasta para arquivos de log)" -ForegroundColor Gray
    
    Write-Host "`nDocumentação útil:" -ForegroundColor Cyan
    Write-Host "  Express: https://expressjs.com/" -ForegroundColor Gray
    Write-Host "  Vite:    https://vitejs.dev/" -ForegroundColor Gray
    
    Write-Host "`nBom desenvolvimento! :)" -ForegroundColor Green
    Write-Host "========================================`n" -ForegroundColor Green
    Read-Host "Pressione Enter para sair"
}

criarPastas
