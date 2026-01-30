<#
.SYNOPSIS
Cria Middlewares de exemplo para o projeto.

.DESCRIPTION
Este módulo cria um arquivo com 4 middlewares úteis:
- authMiddleware: Autenticação com token
- logMiddleware: Log de requisições
- validateUser: Validação de dados de usuário
- errorHandler: Tratamento global de erros

.PARAMETER caminho
O caminho raiz do projeto onde os Middlewares serão criados.

.PARAMETER extensao
A extensão do arquivo (js ou ts).

.EXAMPLE
New-ExampleMiddleware -caminho "C:\meu-projeto" -extensao "ts"

.NOTES
Autor: João Henrique
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
    
    # Define tipagem baseada na extensão
    if ($extensao -eq "ts") {
        $tipoReqRes = "req: Request, res: Response, next: NextFunction"
        $importExpress = "import { Request, Response, NextFunction } from 'express';"
    }
    else {
        $tipoReqRes = "req, res, next"
        $importExpress = ""
    }
    
    # Conteúdo dos Middlewares
    $conteudoMiddleware = @"
$importExpress

/**
 * Middleware de autenticação de exemplo
 */
export const authMiddleware = ($tipoReqRes) => {
    const token = req.headers.authorization;
    
    if (!token) {
        return res.status(401).json({
            success: false,
            message: 'Token não fornecido'
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
            message: 'Token inválido'
        });
    }
};

/**
 * Middleware de log de requisições
 */
export const logMiddleware = ($tipoReqRes) => {
    const timestamp = new Date().toISOString();
    console.log('['+ timestamp + ']', req.method, req.path);
    next();
};

/**
 * Middleware de validação de dados
 */
export const validateUser = ($tipoReqRes) => {
    const { name, email } = req.body;
    
    if (!name || name.trim() === '') {
        return res.status(400).json({
            success: false,
            message: 'Nome é obrigatório'
        });
    }
    
    if (!email || !email.includes('@')) {
        return res.status(400).json({
            success: false,
            message: 'Email inválido'
        });
    }
    
    next();
};

/**
 * Middleware de tratamento de erros
 */
export const errorHandler = (err, $tipoReqRes) => {
    console.error(err.stack);
    
    return res.status(err.status || 500).json({
        success: false,
        message: err.message || 'Erro interno do servidor',
        ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
    });
};
"@

    # Cria o arquivo no diretório Middleware
    $arquivoMiddleware = "middlewares.$extensao"
    $caminhoCompleto = "$caminho\Middleware\$arquivoMiddleware"
    
    try {
        New-Item -Path $caminhoCompleto -ItemType File -Value $conteudoMiddleware -Force | Out-Null
        Write-Host "  ✓ Middleware criado: $arquivoMiddleware" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "  ✗ Erro ao criar Middleware: $_" -ForegroundColor Red
        return $false
    }
}

Export-ModuleMember -Function New-ExampleMiddleware
