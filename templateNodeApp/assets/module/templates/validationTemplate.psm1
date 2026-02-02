<#
.SYNOPSIS
Cria arquivo de validação com express-validator.

.DESCRIPTION
Este módulo cria validações reutilizáveis usando express-validator
para sanitização e validação de entrada de dados.

.PARAMETER caminho
O caminho raiz do projeto.

.PARAMETER extensao
A extensão do arquivo (js ou ts).

.EXAMPLE
New-ValidationModule -caminho "C:\meu-projeto" -extensao "ts"

.NOTES
Autor: João Henrique
Data: 02/02/2026
#>

function New-ValidationModule {
    param(
        [Parameter(Mandatory = $true)]
        [string]$caminho,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("js", "ts")]
        [string]$extensao = "js"
    )
    
    # Conteúdo do módulo de validação
    $conteudoValidation = @"
import { body, param, validationResult } from 'express-validator';

/**
 * Middleware para verificar erros de validação
 */
export const handleValidationErrors = (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({
            success: false,
            message: 'Erro de validação',
            errors: errors.array()
        });
    }
    next();
};

/**
 * Validações para usuários
 */
export const userValidation = {
    // Validação para criar usuário
    create: [
        body('name')
            .trim()
            .notEmpty().withMessage('Nome é obrigatório')
            .isLength({ min: 2, max: 100 }).withMessage('Nome deve ter entre 2 e 100 caracteres')
            .escape(),
        body('email')
            .trim()
            .notEmpty().withMessage('Email é obrigatório')
            .isEmail().withMessage('Email inválido')
            .normalizeEmail(),
        body('password')
            .optional()
            .isLength({ min: 6 }).withMessage('Senha deve ter pelo menos 6 caracteres')
            .matches(/\d/).withMessage('Senha deve conter pelo menos um número'),
        handleValidationErrors
    ],
    
    // Validação para atualizar usuário
    update: [
        param('id')
            .isInt({ min: 1 }).withMessage('ID inválido'),
        body('name')
            .optional()
            .trim()
            .isLength({ min: 2, max: 100 }).withMessage('Nome deve ter entre 2 e 100 caracteres')
            .escape(),
        body('email')
            .optional()
            .trim()
            .isEmail().withMessage('Email inválido')
            .normalizeEmail(),
        handleValidationErrors
    ],
    
    // Validação para buscar por ID
    getById: [
        param('id')
            .isInt({ min: 1 }).withMessage('ID deve ser um número positivo'),
        handleValidationErrors
    ],
    
    // Validação para deletar
    delete: [
        param('id')
            .isInt({ min: 1 }).withMessage('ID deve ser um número positivo'),
        handleValidationErrors
    ]
};

/**
 * Validações para autenticação
 */
export const authValidation = {
    // Validação para login
    login: [
        body('email')
            .trim()
            .notEmpty().withMessage('Email é obrigatório')
            .isEmail().withMessage('Email inválido')
            .normalizeEmail(),
        body('password')
            .notEmpty().withMessage('Senha é obrigatória'),
        handleValidationErrors
    ],
    
    // Validação para registro
    register: [
        body('name')
            .trim()
            .notEmpty().withMessage('Nome é obrigatório')
            .isLength({ min: 2, max: 100 }).withMessage('Nome deve ter entre 2 e 100 caracteres')
            .escape(),
        body('email')
            .trim()
            .notEmpty().withMessage('Email é obrigatório')
            .isEmail().withMessage('Email inválido')
            .normalizeEmail(),
        body('password')
            .notEmpty().withMessage('Senha é obrigatória')
            .isLength({ min: 6 }).withMessage('Senha deve ter pelo menos 6 caracteres')
            .matches(/\d/).withMessage('Senha deve conter pelo menos um número'),
        handleValidationErrors
    ]
};

/**
 * Validação genérica para sanitizar strings
 */
export const sanitizeString = (fieldName) => {
    return body(fieldName)
        .trim()
        .escape();
};
"@
    
    # Cria o arquivo de validação
    $arquivoValidation = "validation.$extensao"
    $pastaHelpers = Join-Path $caminho "Helpers"
    $caminhoValidation = Join-Path $pastaHelpers $arquivoValidation
    
    if (-not (Test-Path -Path $pastaHelpers)) {
        New-Item -Path $pastaHelpers -ItemType Directory -Force | Out-Null
    }
    
    try {
        New-Item -Path $caminhoValidation -ItemType File -Value $conteudoValidation -Force | Out-Null
        Write-Host "  [OK] Módulo de validação criado: $caminhoValidation" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "  [ERRO] Erro ao criar módulo de validação: $_" -ForegroundColor Red
        return $false
    }
}

Export-ModuleMember -Function New-ValidationModule
