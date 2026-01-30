<#
.SYNOPSIS
Cria um Model de exemplo para o projeto.

.DESCRIPTION
Este módulo cria um arquivo User model com métodos estáticos e de instância
para operações básicas de banco de dados.

.PARAMETER caminho
O caminho raiz do projeto onde o Model será criado.

.PARAMETER extensao
A extensão do arquivo (js ou ts).

.EXAMPLE
New-ExampleModel -caminho "C:\meu-projeto" -extensao "ts"

.NOTES
Autor: João Henrique
Data: 30/01/2026
#>

function New-ExampleModel {
    param(
        [Parameter(Mandatory = $true)]
        [string]$caminho,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("js", "ts")]
        [string]$extensao = "js"
    )
    
    # Adiciona interface TypeScript se necessário
    if ($extensao -eq "ts") {
        $interfaceUser = @"
interface IUser {
    id?: number;
    name: string;
    email: string;
    password?: string;
    createdAt?: Date;
    updatedAt?: Date;
}

"@
    }
    else {
        $interfaceUser = ""
    }
    
    # Conteúdo do Model
    $conteudoModel = @"
$interfaceUser/**
 * Model de exemplo para Usuário
 * Este é um exemplo básico. Em produção, use um ORM como Sequelize, TypeORM ou Prisma
 */
class User {
    constructor(data) {
        this.id = data.id;
        this.name = data.name;
        this.email = data.email;
        this.password = data.password;
        this.createdAt = data.createdAt || new Date();
        this.updatedAt = data.updatedAt || new Date();
    }
    
    /**
     * Encontra todos os usuários
     */
    static async findAll() {
        // TODO: Implementar busca no banco de dados
        return [];
    }
    
    /**
     * Encontra um usuário por ID
     */
    static async findById(id) {
        // TODO: Implementar busca no banco de dados
        return null;
    }
    
    /**
     * Encontra um usuário por email
     */
    static async findByEmail(email) {
        // TODO: Implementar busca no banco de dados
        return null;
    }
    
    /**
     * Cria um novo usuário
     */
    static async create(data) {
        // TODO: Implementar criação no banco de dados
        return new User(data);
    }
    
    /**
     * Atualiza o usuário
     */
    async update(data) {
        // TODO: Implementar atualização no banco de dados
        Object.assign(this, data);
        this.updatedAt = new Date();
        return this;
    }
    
    /**
     * Remove o usuário
     */
    async delete() {
        // TODO: Implementar remoção no banco de dados
        return true;
    }
}

export default User;
"@

    # Cria o arquivo no diretório Models
    $arquivoModel = "User.$extensao"
    $caminhoCompleto = "$caminho\Models\$arquivoModel"
    
    try {
        New-Item -Path $caminhoCompleto -ItemType File -Value $conteudoModel -Force | Out-Null
        Write-Host "  ✓ Model criado: $arquivoModel" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "  ✗ Erro ao criar Model: $_" -ForegroundColor Red
        return $false
    }
}

Export-ModuleMember -Function New-ExampleModel
