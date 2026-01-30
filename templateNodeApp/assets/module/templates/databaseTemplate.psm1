<#
.SYNOPSIS
Cria arquivo de configuracao de banco de dados para o projeto.

.DESCRIPTION
Este modulo cria um arquivo database com configuracoes para
SQLite, PostgreSQL, MySQL e MongoDB.

.PARAMETER caminho
O caminho raiz do projeto onde a configuracao sera criada.

.PARAMETER extensao
A extensao do arquivo (js ou ts).

.EXAMPLE
New-DatabaseConfig -caminho "C:\meu-projeto" -extensao "js"

.NOTES
Autor: Joao Henrique
Data: 30/01/2026
#>

function New-DatabaseConfig {
    param(
        [Parameter(Mandatory = $true)]
        [string]$caminho,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("js", "ts")]
        [string]$extensao = "js"
    )
    
    # Conteudo da configuracao de banco de dados
    $conteudoConfig = @"
/**
 * Configuracao de conexao com banco de dados
 * Este e um exemplo basico. Adapte conforme o banco de dados escolhido.
 */

// Para SQLite (recomendado para desenvolvimento)
// npm install sqlite3

// Para PostgreSQL
// npm install pg

// Para MySQL
// npm install mysql2

// Para MongoDB
// npm install mongodb
import dotenv from 'dotenv';
dotenv.config();
const dbConfig = {
    // SQLite
    sqlite: {
        filename: './Database/database.sqlite',
        driver: 'sqlite3'
    },
    
    // PostgreSQL
    postgres: {
        host: process.env.DB_HOST || 'localhost',
        port: process.env.DB_PORT || 5432,
        database: process.env.DB_NAME || 'myapp',
        user: process.env.DB_USER || 'postgres',
        password: process.env.DB_PASSWORD || ''
    },
    
    // MySQL
    mysql: {
        host: process.env.DB_HOST || 'localhost',
        port: process.env.DB_PORT || 3306,
        database: process.env.DB_NAME || 'myapp',
        user: process.env.DB_USER || 'root',
        password: process.env.DB_PASSWORD || ''
    },
    
    // MongoDB
    mongodb: {
        url: process.env.MONGODB_URL || 'mongodb://localhost:27017/myapp'
    }
};

export default dbConfig;
"@

    # Cria o arquivo no diretorio Config
    $arquivoConfig = "database.$extensao"
    $pastaConfig = "$caminho\Config"
    $caminhoCompleto = "$pastaConfig\$arquivoConfig"
    
    # Verifica se a pasta Config existe
    if (-not (Test-Path -Path $pastaConfig)) {
        Write-Host "  [AVISO] Pasta Config nao existe em: $pastaConfig" -ForegroundColor Yellow
        Write-Host "  Criando pasta Config..." -ForegroundColor Yellow
        New-Item -Path $pastaConfig -ItemType Directory -Force | Out-Null
    }
    
    try {
        New-Item -Path $caminhoCompleto -ItemType File -Value $conteudoConfig -Force | Out-Null
        Write-Host "  [OK] Configuracao de banco criada: $caminhoCompleto" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "  [ERRO] Erro ao criar configuracao de banco: $_" -ForegroundColor Red
        Write-Host "  Caminho tentado: $caminhoCompleto" -ForegroundColor Red
        return $false
    }
}

Export-ModuleMember -Function New-DatabaseConfig
