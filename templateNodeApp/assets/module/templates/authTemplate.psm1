<#
.SYNOPSIS
Cria módulo de autenticação JWT completo.

.DESCRIPTION
Este módulo cria arquivos relacionados à autenticação JWT:
- AuthController para login/registro
- AuthService com lógica de autenticação
- Middleware JWT atualizado com validação real

.PARAMETER caminho
O caminho raiz do projeto.

.PARAMETER extensao
A extensão do arquivo (js ou ts).

.EXAMPLE
New-AuthModule -caminho "C:\meu-projeto" -extensao "ts"

.NOTES
Autor: João Henrique
Data: 02/02/2026
#>

function New-AuthModule {
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
        $importJWT = "import jwt from 'jsonwebtoken';"
        $importBcrypt = "import bcrypt from 'bcrypt';"
        $catchError = "catch (error: any)"
        $returnType = ": Promise<void>"
    }
    else {
        $tipoReqRes = "req, res"
        $importExpress = ""
        $importJWT = "import jwt from 'jsonwebtoken';"
        $importBcrypt = "import bcrypt from 'bcrypt';"
        $catchError = "catch (error)"
        $returnType = ""
    }
    
    # AuthController
    $conteudoAuthController = @"
$importExpress
$importJWT
$importBcrypt

/**
 * Controller de autenticação
 */
class AuthController {
    /**
     * Login de usuário
     */
    async login($tipoReqRes)$returnType {
        try {
            const { email, password } = req.body;
            
            if (!email || !password) {
                return res.status(400).json({
                    success: false,
                    message: 'Email e senha são obrigatórios'
                });
            }
            
            // TODO: Buscar usuário no banco de dados
            // const user = await User.findByEmail(email);
            const user = { 
                id: 1, 
                email: 'usuario@example.com', 
                password: await bcrypt.hash('senha123', 10),
                name: 'Usuário Teste'
            };
            
            if (!user) {
                return res.status(401).json({
                    success: false,
                    message: 'Credenciais inválidas'
                });
            }
            
            // Verifica a senha
            const passwordMatch = await bcrypt.compare(password, user.password);
            if (!passwordMatch) {
                return res.status(401).json({
                    success: false,
                    message: 'Credenciais inválidas'
                });
            }
            
            // Gera o token JWT
            const token = jwt.sign(
                { id: user.id, email: user.email },
                process.env.JWT_SECRET || 'seu-secret-super-secreto',
                { expiresIn: '24h' }
            );
            
            return res.status(200).json({
                success: true,
                message: 'Login realizado com sucesso',
                data: {
                    user: {
                        id: user.id,
                        email: user.email,
                        name: user.name
                    },
                    token
                }
            });
        } $catchError {
            return res.status(500).json({
                success: false,
                message: 'Erro ao realizar login',
                error: error.message
            });
        }
    }
    
    /**
     * Registro de novo usuário
     */
    async register($tipoReqRes)$returnType {
        try {
            const { name, email, password } = req.body;
            
            if (!name || !email || !password) {
                return res.status(400).json({
                    success: false,
                    message: 'Nome, email e senha são obrigatórios'
                });
            }
            
            if (password.length < 6) {
                return res.status(400).json({
                    success: false,
                    message: 'Senha deve ter pelo menos 6 caracteres'
                });
            }
            
            // TODO: Verificar se email já existe
            // const existingUser = await User.findByEmail(email);
            
            // Hash da senha
            const hashedPassword = await bcrypt.hash(password, 10);
            
            // TODO: Criar usuário no banco de dados
            const newUser = {
                id: Date.now(),
                name,
                email,
                password: hashedPassword
            };
            
            // Gera o token JWT
            const token = jwt.sign(
                { id: newUser.id, email: newUser.email },
                process.env.JWT_SECRET || 'seu-secret-super-secreto',
                { expiresIn: '24h' }
            );
            
            return res.status(201).json({
                success: true,
                message: 'Usuário registrado com sucesso',
                data: {
                    user: {
                        id: newUser.id,
                        email: newUser.email,
                        name: newUser.name
                    },
                    token
                }
            });
        } $catchError {
            return res.status(500).json({
                success: false,
                message: 'Erro ao registrar usuário',
                error: error.message
            });
        }
    }
    
    /**
     * Verifica token JWT
     */
    async verifyToken($tipoReqRes)$returnType {
        try {
            const token = req.headers.authorization?.replace('Bearer ', '');
            
            if (!token) {
                return res.status(401).json({
                    success: false,
                    message: 'Token não fornecido'
                });
            }
            
            const decoded = jwt.verify(
                token,
                process.env.JWT_SECRET || 'seu-secret-super-secreto'
            );
            
            return res.status(200).json({
                success: true,
                message: 'Token válido',
                data: decoded
            });
        } $catchError {
            return res.status(401).json({
                success: false,
                message: 'Token inválido',
                error: error.message
            });
        }
    }
}

export default new AuthController();
"@
    
    # Cria o AuthController
    $arquivoAuthController = "AuthController.$extensao"
    $pastaControllers = Join-Path $caminho "Controllers"
    $caminhoAuthController = Join-Path $pastaControllers $arquivoAuthController
    
    try {
        New-Item -Path $caminhoAuthController -ItemType File -Value $conteudoAuthController -Force | Out-Null
        Write-Host "  [OK] AuthController criado: $caminhoAuthController" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "  [ERRO] Erro ao criar AuthController: $_" -ForegroundColor Red
        return $false
    }
}

Export-ModuleMember -Function New-AuthModule
