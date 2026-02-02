<#
.SYNOPSIS
Cria um Controller de exemplo para o projeto.

.DESCRIPTION
Este modulo cria um arquivo UserController com CRUD completo,
incluindo metodos para listar, buscar, criar, atualizar e deletar usuarios.

.PARAMETER caminho
O caminho raiz do projeto onde o Controller sera criado.

.PARAMETER extensao
A extensao do arquivo (js ou ts).

.EXAMPLE
New-ExampleController -caminho "C:\meu-projeto" -extensao "js"

.NOTES
Autor: Joao Henrique
Data: 30/01/2026
#>

function New-ExampleController {
    param(
        [Parameter(Mandatory = $true)]
        [string]$caminho,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("js", "ts")]
        [string]$extensao = "js"
    )
    
    # Define tipagem baseada na extensao
    if ($extensao -eq "ts") {
        $tipoReqRes = "req: Request, res: Response"
        $importExpress = "import { Request, Response } from 'express';"
        $catchError = "catch (error: any)"
        $returnType = ": Promise<void>"
    }
    else {
        $tipoReqRes = "req, res"
        $importExpress = ""
        $catchError = "catch (error)"
        $returnType = ""
    }
    
    # Conteudo do Controller
    $conteudoController = @"
$importExpress
import UserService from '../Services/UserService';

/**
 * Controller de exemplo para gerenciar usuarios
 */
class UserController {
    /**
     * Lista todos os usuarios
     */
    async index($tipoReqRes)$returnType {
        try {
            const result = await UserService.getAllUsers();
            
            if (!result.success) {
                return res.status(500).json(result);
            }
            
            return res.status(200).json(result);
        } $catchError {
            return res.status(500).json({
                success: false,
                message: 'Erro ao buscar usuarios',
                error: error.message
            });
        }
    }
    
    /**
     * Busca um usuario especifico por ID
     */
    async show($tipoReqRes)$returnType {
        try {
            const { id } = req.params;
            const result = await UserService.getUserById(Number(id));
            
            if (!result.success) {
                return res.status(404).json(result);
            }
            
            return res.status(200).json(result);
        } $catchError {
            return res.status(500).json({
                success: false,
                message: 'Erro ao buscar usuario',
                error: error.message
            });
        }
    }
    
    /**
     * Cria um novo usuario
     */
    async store($tipoReqRes)$returnType {
        try {
            const { name, email } = req.body;
            const result = await UserService.createUser({ name, email });
            
            if (!result.success) {
                return res.status(400).json(result);
            }
            
            return res.status(201).json(result);
        } $catchError {
            return res.status(500).json({
                success: false,
                message: 'Erro ao criar usuario',
                error: error.message
            });
        }
    }
    
    /**
     * Atualiza um usuario existente
     */
    async update($tipoReqRes)$returnType {
        try {
            const { id } = req.params;
            const { name, email } = req.body;
            const result = await UserService.updateUser(Number(id), { name, email });
            
            if (!result.success) {
                return res.status(400).json(result);
            }
            
            return res.status(200).json(result);
        } $catchError {
            return res.status(500).json({
                success: false,
                message: 'Erro ao atualizar usuario',
                error: error.message
            });
        }
    }
    
    /**
     * Remove um usuario
     */
    async destroy($tipoReqRes)$returnType {
        try {
            const { id } = req.params;
            const result = await UserService.deleteUser(Number(id));
            
            if (!result.success) {
                return res.status(400).json(result);
            }
            
            return res.status(200).json(result);
        } $catchError {
            return res.status(500).json({
                success: false,
                message: 'Erro ao remover usuario',
                error: error.message
            });
        }
    }
}

export default new UserController();
"@

    # Cria o arquivo no diretorio Controllers
    $arquivoController = "UserController.$extensao"
    $pastaControllers = "$caminho\Controllers"
    $caminhoCompleto = "$pastaControllers\$arquivoController"
    
    # Verifica se a pasta Controllers existe
    if (-not (Test-Path -Path $pastaControllers)) {
        Write-Host "  [AVISO] Pasta Controllers nao existe em: $pastaControllers" -ForegroundColor Yellow
        Write-Host "  Criando pasta Controllers..." -ForegroundColor Yellow
        New-Item -Path $pastaControllers -ItemType Directory -Force | Out-Null
    }
    
    try {
        New-Item -Path $caminhoCompleto -ItemType File -Value $conteudoController -Force | Out-Null
        Write-Host "  [OK] Controller criado: $caminhoCompleto" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "  [ERRO] Erro ao criar Controller: $_" -ForegroundColor Red
        Write-Host "  Caminho tentado: $caminhoCompleto" -ForegroundColor Red
        return $false
    }
}

Export-ModuleMember -Function New-ExampleController
