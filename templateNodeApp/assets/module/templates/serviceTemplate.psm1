<#
.SYNOPSIS
Cria um Service de exemplo para o projeto.

.DESCRIPTION
Este módulo cria um arquivo UserService com lógica de negócio
para gerenciamento de usuários.

.PARAMETER caminho
O caminho raiz do projeto onde o Service será criado.

.PARAMETER extensao
A extensão do arquivo (js ou ts).

.EXAMPLE
New-ExampleService -caminho "C:\meu-projeto" -extensao "js"

.NOTES
Autor: João Henrique
Data: 30/01/2026
#>

function New-ExampleService {
    param(
        [Parameter(Mandatory = $true)]
        [string]$caminho,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("js", "ts")]
        [string]$extensao = "js"
    )
    
    # Conteúdo do Service
    $conteudoService = @"
import User from '../Models/User.$extensao';

/**
 * Service de exemplo para lógica de negócio de usuários
 * Services contêm a lógica de negócio e são chamados pelos Controllers
 */
class UserService {
    /**
     * Lista todos os usuários
     */
    async getAllUsers() {
        try {
            const users = await User.findAll();
            return {
                success: true,
                data: users
            };
        } catch (error) {
            return {
                success: false,
                message: 'Erro ao buscar usuários',
                error: error.message
            };
        }
    }
    
    /**
     * Busca um usuário por ID
     */
    async getUserById(id) {
        try {
            const user = await User.findById(id);
            
            if (!user) {
                return {
                    success: false,
                    message: 'Usuário não encontrado'
                };
            }
            
            return {
                success: true,
                data: user
            };
        } catch (error) {
            return {
                success: false,
                message: 'Erro ao buscar usuário',
                error: error.message
            };
        }
    }
    
    /**
     * Cria um novo usuário
     */
    async createUser(data) {
        try {
            // Validações
            if (!data.name || !data.email) {
                return {
                    success: false,
                    message: 'Nome e email são obrigatórios'
                };
            }
            
            // Verifica se o email já existe
            const existingUser = await User.findByEmail(data.email);
            if (existingUser) {
                return {
                    success: false,
                    message: 'Email já cadastrado'
                };
            }
            
            // Cria o usuário
            const user = await User.create(data);
            
            return {
                success: true,
                message: 'Usuário criado com sucesso',
                data: user
            };
        } catch (error) {
            return {
                success: false,
                message: 'Erro ao criar usuário',
                error: error.message
            };
        }
    }
    
    /**
     * Atualiza um usuário
     */
    async updateUser(id, data) {
        try {
            const user = await User.findById(id);
            
            if (!user) {
                return {
                    success: false,
                    message: 'Usuário não encontrado'
                };
            }
            
            await user.update(data);
            
            return {
                success: true,
                message: 'Usuário atualizado com sucesso',
                data: user
            };
        } catch (error) {
            return {
                success: false,
                message: 'Erro ao atualizar usuário',
                error: error.message
            };
        }
    }
    
    /**
     * Remove um usuário
     */
    async deleteUser(id) {
        try {
            const user = await User.findById(id);
            
            if (!user) {
                return {
                    success: false,
                    message: 'Usuário não encontrado'
                };
            }
            
            await user.delete();
            
            return {
                success: true,
                message: 'Usuário removido com sucesso'
            };
        } catch (error) {
            return {
                success: false,
                message: 'Erro ao remover usuário',
                error: error.message
            };
        }
    }
}

export default new UserService();
"@

    # Cria o arquivo no diretório Services
    $arquivoService = "UserService.$extensao"
    $caminhoCompleto = "$caminho\Services\$arquivoService"
    
    try {
        New-Item -Path $caminhoCompleto -ItemType File -Value $conteudoService -Force | Out-Null
        Write-Host "  ✓ Service criado: $arquivoService" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "  ✗ Erro ao criar Service: $_" -ForegroundColor Red
        return $false
    }
}

Export-ModuleMember -Function New-ExampleService
