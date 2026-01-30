<#
.SYNOPSIS
Cria um Model de exemplo para o projeto.

.DESCRIPTION
Este modulo cria um arquivo User model com metodos estaticos e de instancia
para operacoes basicas de banco de dados.

.PARAMETER caminho
O caminho raiz do projeto onde o Model sera criado.

.PARAMETER extensao
A extensao do arquivo (js ou ts).

.EXAMPLE
New-ExampleModel -caminho "C:\meu-projeto" -extensao "ts"

.NOTES
Autor: Joao Henrique
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
    
    # Adiciona interface TypeScript se necessario
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
    
    # Conteudo do Model
    $conteudoModel = @"
$interfaceUser/**
 * Model de exemplo para Usuario
 * Este e um exemplo basico. Em producao, use um ORM como Sequelize, TypeORM ou Prisma
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
     * Encontra todos os usuarios
     */
    static async findAll() {
        // TODO: Implementar busca no banco de dados
        return [];
    }
    
    /**
     * Encontra um usuario por ID
     */
    static async findById(id) {
        // TODO: Implementar busca no banco de dados
        return null;
    }
    
    /**
     * Encontra um usuario por email
     */
    static async findByEmail(email) {
        // TODO: Implementar busca no banco de dados
        return null;
    }
    
    /**
     * Cria um novo usuario
     */
    static async create(data) {
        // TODO: Implementar criacao no banco de dados
        return new User(data);
    }
    
    /**
     * Atualiza o usuario
     */
    async update(data) {
        // TODO: Implementar atualizacao no banco de dados
        Object.assign(this, data);
        this.updatedAt = new Date();
        return this;
    }
    
    /**
     * Remove o usuario
     */
    async delete() {
        // TODO: Implementar remocao no banco de dados
        return true;
    }
}

export default User;
"@

    # Cria o arquivo no diretorio Models
    $arquivoModel = "User.$extensao"
    $pastaModels = "$caminho\Models"
    $caminhoCompleto = "$pastaModels\$arquivoModel"
    
    # Verifica se a pasta Models existe
    if (-not (Test-Path -Path $pastaModels)) {
        Write-Host "  [AVISO] Pasta Models nao existe em: $pastaModels" -ForegroundColor Yellow
        Write-Host "  Criando pasta Models..." -ForegroundColor Yellow
        New-Item -Path $pastaModels -ItemType Directory -Force | Out-Null
    }
    
    try {
        New-Item -Path $caminhoCompleto -ItemType File -Value $conteudoModel -Force | Out-Null
        Write-Host "  [OK] Model criado: $caminhoCompleto" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "  [ERRO] Erro ao criar Model: $_" -ForegroundColor Red
        Write-Host "  Caminho tentado: $caminhoCompleto" -ForegroundColor Red
        return $false
    }
}

Export-ModuleMember -Function New-ExampleModel
