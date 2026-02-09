<#
.SYNOPSIS
Cria Middlewares de exemplo para o projeto.

.DESCRIPTION
Este modulo cria um arquivo com 4 middlewares uteis:
- authMiddleware: Autenticacao com token
- logMiddleware: Log de requisicoes
- validateUser: Validacao de dados de usuario
- errorHandler: Tratamento global de erros

.PARAMETER caminho
O caminho raiz do projeto onde os Middlewares serao criados.

.PARAMETER extensao
A extensao do arquivo (js ou ts).

.EXAMPLE
New-ExampleMiddleware -caminho "C:\meu-projeto" -extensao "ts"

.NOTES
Autor: Joao Henrique
Data: 30/01/2026
#>

function New-ExampleMiddleware {
    param(
        [Parameter(Mandatory = $true)]
        [string]$caminho,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("js", "ts")]
        [string]$extensao = "js"
    )
    
    # Define tipagem baseada na extensao
    if ($extensao -eq "ts") {
        $tipoReqRes = "req: Request, res: Response, next: NextFunction"
        $importExpress = "import { Request, Response, NextFunction } from 'express';"
        $errorHandlerParam = "err: any"
        $returnType = ": void"
    }
    else {
        $tipoReqRes = "req, res, next"
        $importExpress = ""
        $errorHandlerParam = "err"
        $returnType = ""
    }
    
    # Conteudo dos Middlewares
    $conteudoMiddleware = @"
$importExpress

/**
 * Middleware de autenticacao de exemplo
 */
export const authMiddleware = ($tipoReqRes)$returnType => {
    const token = req.headers.authorization;
    
    if (!token) {
        return res.status(401).json({
            success: false,
            message: 'Token nao fornecido'
        });
    }
    
    try {
        // TODO: Validar o token (JWT, por exemplo)
        // const decoded = jwt.verify(token, process.env.JWT_SECRET);
        // req.user = decoded;
        
        next();
    } catch (error) {
        return res.status(401).json({
            success: false,
            message: 'Token invalido'
        });
    }
};

/**
 * Middleware de log de requisicoes
 */
export const logMiddleware = ($tipoReqRes)$returnType => {
    const timestamp = new Date().toISOString();
    console.log('['+ timestamp + ']', req.method, req.path);
    next();
};

/**
 * Middleware de validacao de dados
 */
export const validateUser = ($tipoReqRes)$returnType => {
    const { name, email } = req.body;
    
    if (!name || name.trim() === '') {
        return res.status(400).json({
            success: false,
            message: 'Nome e obrigatorio'
        });
    }
    
    if (!email || !email.includes('@')) {
        return res.status(400).json({
            success: false,
            message: 'Email invalido'
        });
    }
    
    next();
};

/**
 * Middleware de tratamento de erros
 */
export const errorHandler = ($errorHandlerParam, $tipoReqRes)$returnType => {
    console.error(err.stack);
    
    res.status(err.status || 500).json({
        success: false,
        message: err.message || 'Erro interno do servidor',
        ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
    });
};
"@

    # Cria o arquivo no diretorio Middleware
    $arquivoMiddleware = "middlewares.$extensao"
    $pastaMiddleware = "$caminho\Middleware"
    $caminhoCompleto = "$pastaMiddleware\$arquivoMiddleware"
    
    # Verifica se a pasta Middleware existe
    if (-not (Test-Path -Path $pastaMiddleware)) {
        Write-Host "  [AVISO] Pasta Middleware nao existe em: $pastaMiddleware" -ForegroundColor Yellow
        Write-Host "  Criando pasta Middleware..." -ForegroundColor Yellow
        New-Item -Path $pastaMiddleware -ItemType Directory -Force | Out-Null
    }
    
    try {
        New-Item -Path $caminhoCompleto -ItemType File -Value $conteudoMiddleware -Force | Out-Null
        Write-Host "  [OK] Middleware criado: $caminhoCompleto" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "  [ERRO] Erro ao criar Middleware: $_" -ForegroundColor Red
        Write-Host "  Caminho tentado: $caminhoCompleto" -ForegroundColor Red
        return $false
    }
}

Export-ModuleMember -Function New-ExampleMiddleware
