<#
.SYNOPSIS
Cria um Controller de exemplo para o projeto.

.DESCRIPTION
Este módulo cria um arquivo UserController com CRUD completo,
incluindo métodos para listar, buscar, criar, atualizar e deletar usuários.

.PARAMETER caminho
O caminho raiz do projeto onde o Controller será criado.

.PARAMETER extensao
A extensão do arquivo (js ou ts).

.EXAMPLE
New-ExampleController -caminho "C:\meu-projeto" -extensao "js"

.NOTES
Autor: João Henrique
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
    
    # Define tipagem baseada na extensão
    if ($extensao -eq "ts") {
        $tipoReqRes = "req: Request, res: Response"
        $importExpress = "import { Request, Response } from 'express';"
    }
    else {
        $tipoReqRes = "req, res"
        $importExpress = ""
    }
    
    # Conteúdo do Controller
    $conteudoController = @"
$importExpress

/**
 * Controller de exemplo para gerenciar usuários
 */
class UserController {
    /**
     * Lista todos os usuários
     */
    async index($tipoReqRes) {
        try {
            // TODO: Buscar usuários do banco de dados
            const users = [
                { id: 1, name: 'João Silva', email: 'joao@example.com' },
                { id: 2, name: 'Maria Santos', email: 'maria@example.com' }
            ];
            
            return res.status(200).json({
                success: true,
                data: users
            });
        } catch (error) {
            return res.status(500).json({
                success: false,
                message: 'Erro ao buscar usuários',
                error: error.message
            });
        }
    }
    
    /**
     * Busca um usuário específico por ID
     */
    async show($tipoReqRes) {
        try {
            const { id } = req.params;
            
            // TODO: Buscar usuário do banco de dados
            const user = { id, name: 'João Silva', email: 'joao@example.com' };
            
            return res.status(200).json({
                success: true,
                data: user
            });
        } catch (error) {
            return res.status(500).json({
                success: false,
                message: 'Erro ao buscar usuário',
                error: error.message
            });
        }
    }
    
    /**
     * Cria um novo usuário
     */
    async store($tipoReqRes) {
        try {
            const { name, email } = req.body;
            
            // TODO: Validar dados e salvar no banco
            const newUser = { id: 3, name, email };
            
            return res.status(201).json({
                success: true,
                message: 'Usuário criado com sucesso',
                data: newUser
            });
        } catch (error) {
            return res.status(500).json({
                success: false,
                message: 'Erro ao criar usuário',
                error: error.message
            });
        }
    }
    
    /**
     * Atualiza um usuário existente
     */
    async update($tipoReqRes) {
        try {
            const { id } = req.params;
            const { name, email } = req.body;
            
            // TODO: Atualizar usuário no banco de dados
            const updatedUser = { id, name, email };
            
            return res.status(200).json({
                success: true,
                message: 'Usuário atualizado com sucesso',
                data: updatedUser
            });
        } catch (error) {
            return res.status(500).json({
                success: false,
                message: 'Erro ao atualizar usuário',
                error: error.message
            });
        }
    }
    
    /**
     * Remove um usuário
     */
    async destroy($tipoReqRes) {
        try {
            const { id } = req.params;
            
            // TODO: Remover usuário do banco de dados
            
            return res.status(200).json({
                success: true,
                message: 'Usuário removido com sucesso'
            });
        } catch (error) {
            return res.status(500).json({
                success: false,
                message: 'Erro ao remover usuário',
                error: error.message
            });
        }
    }
}

export default new UserController();
"@

    # Cria o arquivo no diretório Controllers
    $arquivoController = "UserController.$extensao"
    $caminhoCompleto = "$caminho\Controllers\$arquivoController"
    
    try {
        New-Item -Path $caminhoCompleto -ItemType File -Value $conteudoController -Force | Out-Null
        Write-Host "  ✓ Controller criado: $arquivoController" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "  ✗ Erro ao criar Controller: $_" -ForegroundColor Red
        return $false
    }
}

Export-ModuleMember -Function New-ExampleController
