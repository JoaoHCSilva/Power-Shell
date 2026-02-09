<#
.SYNOPSIS
Cria configuração Docker para o projeto.

.DESCRIPTION
Este módulo cria Dockerfile, docker-compose.yml e .dockerignore
para containerização da aplicação.

.PARAMETER caminho
O caminho raiz do projeto.

.PARAMETER extensao
A extensão do arquivo (js ou ts).

.EXAMPLE
New-DockerConfig -caminho "C:\meu-projeto" -extensao "ts"

.NOTES
Autor: João Henrique
Data: 02/02/2026
#>

function New-DockerConfig {
    param(
        [Parameter(Mandatory = $true)]
        [string]$caminho,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("js", "ts")]
        [string]$extensao = "js"
    )
    
    # Dockerfile
    $dockerfile = @"
# Estágio 1: Build
FROM node:22-alpine AS builder

WORKDIR /app

# Copia package.json e package-lock.json
COPY package*.json ./

# Instala dependências (inclui dev deps para build)
RUN npm ci

# Copia código fonte
COPY . .

# Build do frontend
RUN npm run build

# Estágio 2: Produção
FROM node:22-alpine

WORKDIR /app

# Copia apenas o necessário do estágio de build
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/dist ./dist

# Controla instalação de dependências por ambiente
ARG NODE_ENV=production

# Instala dependências conforme ambiente
RUN if [ "$NODE_ENV" = "production" ]; then npm ci --only=production; else npm ci; fi

# Copia o restante do backend
COPY . .

# Cria usuário não-root
RUN addgroup -S -g 1001 nodejs && \
    adduser -S -u 1001 -G nodejs nodejs && \
    chown -R nodejs:nodejs /app

USER nodejs

# Expõe a porta
EXPOSE 3000

# Variáveis de ambiente
ENV NODE_ENV=production
ENV PORT=3000

# Comando para iniciar a aplicação
CMD ["npm", "start"]
"@
    
    # docker-compose.yml
    $dockerCompose = @"
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile.dev
    ports:
      - "3001:3000"
      - "5174:5173"
    environment:
      - NODE_ENV=development
      - PORT=3000
    volumes:
      - .:/app
      - /app/node_modules
    command: npm run dev:fullstack
    restart: unless-stopped
    networks:
      - app-network

  # Exemplo de serviço de banco de dados (descomente se necessário)
  # postgres:
  #   image: postgres:15-alpine
  #   environment:
  #     POSTGRES_DB: myapp
  #     POSTGRES_USER: user
  #     POSTGRES_PASSWORD: password
  #   ports:
  #     - "5432:5432"
  #   volumes:
  #     - postgres_data:/var/lib/postgresql/data
  #   networks:
  #     - app-network

networks:
  app-network:
    driver: bridge

# volumes:
#   postgres_data:
"@
    
  # docker-compose-dev
  $dockerFileDev = @"

 # Dockerfile para desenvolvimento
FROM node:22-alpine

WORKDIR /app

# Instala dependências globais necessárias
RUN npm install -g concurrently nodemon

# Copia package.json para instalar dependências
COPY package*.json ./

# Instala todas as dependências
RUN npm ci

# Expõe as portas
EXPOSE 3000 5173

# Comando padrão
CMD ["npm", "run", "dev:fullstack"]

@"
    $dockerignore = @"
node_modules
npm-debug.log
.env
.git
.gitignore
README.md
.vscode
.idea
dist
build
coverage
logs
*.log
.DS_Store
Thumbs.db
"@
    
    try {
        # Cria Dockerfile
        New-Item -Path (Join-Path $caminho "Dockerfile") -ItemType File -Value $dockerfile -Force | Out-Null
        Write-Host "  [OK] Dockerfile criado" -ForegroundColor Green
        
        # cria dockerfile de desenvolvimento
        New-Item -Path (Join-Path $caminho "Dockerfile.dev") -ItemType File -Value $dockerFileDev -Force | Out-Null
        Write-Host "  [OK] Dockerfile.dev criado" -ForegroundColor Green
        # Cria docker-compose.yml
        New-Item -Path (Join-Path $caminho "docker-compose.yml") -ItemType File -Value $dockerCompose -Force | Out-Null
        Write-Host "  [OK] docker-compose.yml criado" -ForegroundColor Green
        
        # Cria .dockerignore
        New-Item -Path (Join-Path $caminho ".dockerignore") -ItemType File -Value $dockerignore -Force | Out-Null
        Write-Host "  [OK] .dockerignore criado" -ForegroundColor Green
        
        return $true
    }
    catch {
        Write-Host "  [ERRO] Erro ao criar configuração Docker: $_" -ForegroundColor Red
        return $false
    }
}

Export-ModuleMember -Function New-DockerConfig
