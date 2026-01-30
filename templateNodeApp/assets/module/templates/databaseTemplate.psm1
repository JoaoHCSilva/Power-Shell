<#
.SYNOPSIS
Cria arquivo de configuração de banco de dados para o projeto.

.DESCRIPTION
Este módulo cria um arquivo database com configurações para
SQLite, PostgreSQL, MySQL e MongoDB.

.PARAMETER caminho
O caminho raiz do projeto onde a configuração será criada.

.PARAMETER extensao
A extensão do arquivo (js ou ts).

.EXAMPLE
New-DatabaseConfig -caminho "C:\meu-projeto" -extensao "js"

.NOTES
Autor: João Henrique
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
    
    # Conteúdo da configuração de banco de dados
    $conteudoConfig = @"
/**
 * Configuração de conexão com banco de dados
 * Este é um exemplo básico. Adapte conforme o banco de dados escolhido.
 */

// Para SQLite (recomendado para desenvolvimento)
// npm install sqlite3

// Para PostgreSQL
// npm install pg

// Para MySQL
// npm install mysql2

// Para MongoDB
// npm install mongodb

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

    # Cria o arquivo no diretório Config
    $arquivoConfig = "database.$extensao"
    $caminhoCompleto = "$caminho\Config\$arquivoConfig"
    
    try {
        New-Item -Path $caminhoCompleto -ItemType File -Value $conteudoConfig -Force | Out-Null
        Write-Host "  ✓ Configuração de banco criada: $arquivoConfig" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "  ✗ Erro ao criar configuração de banco: $_" -ForegroundColor Red
        return $false
    }
}

Export-ModuleMember -Function New-DatabaseConfig
