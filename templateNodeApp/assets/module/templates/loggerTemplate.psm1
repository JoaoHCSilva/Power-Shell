<#
.SYNOPSIS
Cria configuração de logging com Winston.

.DESCRIPTION
Este módulo cria configuração profissional de logging usando Winston
com múltiplos transportes e formatação adequada.

.PARAMETER caminho
O caminho raiz do projeto.

.PARAMETER extensao
A extensão do arquivo (js ou ts).

.EXAMPLE
New-LoggerModule -caminho "C:\meu-projeto" -extensao "ts"

.NOTES
Autor: João Henrique
Data: 02/02/2026
#>

function New-LoggerModule {
    param(
        [Parameter(Mandatory = $true)]
        [string]$caminho,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("js", "ts")]
        [string]$extensao = "js"
    )
    
    # Conteúdo do logger
    $conteudoLogger = @"
import winston from 'winston';
import path from 'path';

// Cria o diretório de logs se não existir
const logsDir = path.join(process.cwd(), 'logs');

// Formato personalizado
const customFormat = winston.format.combine(
    winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
    winston.format.errors({ stack: true }),
    winston.format.splat(),
    winston.format.json()
);

// Formato para console (mais legível)
const consoleFormat = winston.format.combine(
    winston.format.colorize(),
    winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
    winston.format.printf(({ timestamp, level, message, ...meta }) => {
        let msg = ''${timestamp}' [''${level}'] ''${message}';
        if (Object.keys(meta).length > 0) {
            msg += ' ' + JSON.stringify(meta);
        }
        return msg;
    })
);

// Cria o logger
const logger = winston.createLogger({
    level: process.env.LOG_LEVEL || 'info',
    format: customFormat,
    defaultMeta: { service: 'api' },
    transports: [
        // Logs de erro em arquivo separado
        new winston.transports.File({
            filename: path.join(logsDir, 'error.log'),
            level: 'error',
            maxsize: 5242880, // 5MB
            maxFiles: 5,
        }),
        // Logs combinados
        new winston.transports.File({
            filename: path.join(logsDir, 'combined.log'),
            maxsize: 5242880, // 5MB
            maxFiles: 5,
        }),
    ],
});

// Se não estiver em produção, loga também no console
if (process.env.NODE_ENV !== 'production') {
    logger.add(new winston.transports.Console({
        format: consoleFormat,
    }));
}

/**
 * Middleware de logging para Express
 */
export const requestLogger = (req, res, next) => {
    const start = Date.now();
    
    // Captura quando a resposta termina
    res.on('finish', () => {
        const duration = Date.now() - start;
        logger.info({
            method: req.method,
            url: req.originalUrl,
            status: res.statusCode,
            duration: ''${duration}ms',
            ip: req.ip || req.connection.remoteAddress,
        });
    });
    
    next();
};

export default logger;
"@
    
    # Cria o arquivo de logger
    $arquivoLogger = "logger.$extensao"
    $pastaConfig = Join-Path $caminho "Config"
    $caminhoLogger = Join-Path $pastaConfig $arquivoLogger
    
    if (-not (Test-Path -Path $pastaConfig)) {
        New-Item -Path $pastaConfig -ItemType Directory -Force | Out-Null
    }
    
    try {
        New-Item -Path $caminhoLogger -ItemType File -Value $conteudoLogger -Force | Out-Null
        Write-Host "  [OK] Logger criado: $caminhoLogger" -ForegroundColor Green
        
        # Atualiza .gitignore para incluir logs
        $gitignorePath = Join-Path $caminho ".gitignore"
        if (Test-Path $gitignorePath) {
            $gitignoreContent = Get-Content $gitignorePath -Raw
            if ($gitignoreContent -notmatch "logs/") {
                Add-Content $gitignorePath "`nlogs/" -Encoding UTF8
                Write-Host "  [OK] Adicionado logs/ ao .gitignore" -ForegroundColor Green
            }
        }
        
        return $true
    }
    catch {
        Write-Host "  [ERRO] Erro ao criar logger: $_" -ForegroundColor Red
        return $false
    }
}

Export-ModuleMember -Function New-LoggerModule
