<#
.SYNOPSIS
Cria um Service de exemplo para o projeto.

.DESCRIPTION
Este modulo cria um arquivo UserService com logica de negocio
para gerenciamento de usuarios.

.PARAMETER caminho
O caminho raiz do projeto onde o Service sera criado.

.PARAMETER extensao
A extensao do arquivo (js ou ts).

.EXAMPLE
New-ExampleService -caminho "C:\meu-projeto" -extensao "js"

.NOTES
Autor: Joao Henrique
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
    
    # Conteudo do Service
    $conteudoService = @"
import User from '../Models/User.$extensao';

/**
 * Service de exemplo para logica de negocio de usuarios
 * Services contem a logica de negocio e sao chamados pelos Controllers
 */
class UserService {
    /**
     * Lista todos os usuarios
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
                message: 'Erro ao buscar usuarios',
                error: error.message
            };
        }
    }
    
    /**
     * Busca um usuario por ID
     */
    async getUserById(id) {
        try {
            const user = await User.findById(id);
            
            if (!user) {
                return {
                    success: false,
                    message: 'Usuario nao encontrado'
                };
            }
            
            return {
                success: true,
                data: user
            };
        } catch (error) {
            return {
                success: false,
                message: 'Erro ao buscar usuario',
                error: error.message
            };
        }
    }
    
    /**
     * Cria um novo usuario
     */
    async createUser(data) {
        try {
            // Validacoes
            if (!data.name || !data.email) {
                return {
                    success: false,
                    message: 'Nome e email sao obrigatorios'
                };
            }
            
            // Verifica se o email ja existe
            const existingUser = await User.findByEmail(data.email);
            if (existingUser) {
                return {
                    success: false,
                    message: 'Email ja cadastrado'
                };
            }
            
            // Cria o usuario
            const user = await User.create(data);
            
            return {
                success: true,
                message: 'Usuario criado com sucesso',
                data: user
            };
        } catch (error) {
            return {
                success: false,
                message: 'Erro ao criar usuario',
                error: error.message
            };
        }
    }
    
    /**
     * Atualiza um usuario
     */
    async updateUser(id, data) {
        try {
            const user = await User.findById(id);
            
            if (!user) {
                return {
                    success: false,
                    message: 'Usuario nao encontrado'
                };
            }
            
            await user.update(data);
            
            return {
                success: true,
                message: 'Usuario atualizado com sucesso',
                data: user
            };
        } catch (error) {
            return {
                success: false,
                message: 'Erro ao atualizar usuario',
                error: error.message
            };
        }
    }
    
    /**
     * Remove um usuario
     */
    async deleteUser(id) {
        try {
            const user = await User.findById(id);
            
            if (!user) {
                return {
                    success: false,
                    message: 'Usuario nao encontrado'
                };
            }
            
            await user.delete();
            
            return {
                success: true,
                message: 'Usuario removido com sucesso'
            };
        } catch (error) {
            return {
                success: false,
                message: 'Erro ao remover usuario',
                error: error.message
            };
        }
    }
}

export default new UserService();
"@

    # Cria o arquivo no diretorio Services
    $arquivoService = "UserService.$extensao"
    $pastaServices = "$caminho\Services"
    $caminhoCompleto = "$pastaServices\$arquivoService"
    
    # Verifica se a pasta Services existe
    if (-not (Test-Path -Path $pastaServices)) {
        Write-Host "  [AVISO] Pasta Services nao existe em: $pastaServices" -ForegroundColor Yellow
        Write-Host "  Criando pasta Services..." -ForegroundColor Yellow
        New-Item -Path $pastaServices -ItemType Directory -Force | Out-Null
    }
    
    try {
        New-Item -Path $caminhoCompleto -ItemType File -Value $conteudoService -Force | Out-Null
        Write-Host "  [OK] Service criado: $caminhoCompleto" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "  [ERRO] Erro ao criar Service: $_" -ForegroundColor Red
        Write-Host "  Caminho tentado: $caminhoCompleto" -ForegroundColor Red
        return $false
    }
}

Export-ModuleMember -Function New-ExampleService
