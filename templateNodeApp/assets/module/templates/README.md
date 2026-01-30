# Módulos de Templates

Esta pasta contém os módulos individuais para criação de templates de projeto.

## 📁 Estrutura

```
templates/
├── controllerTemplate.psm1   # Cria UserController com CRUD completo
├── modelTemplate.psm1         # Cria User Model com métodos de banco
├── serviceTemplate.psm1       # Cria UserService com lógica de negócio
├── middlewareTemplate.psm1    # Cria 4 middlewares úteis
└── databaseTemplate.psm1      # Cria configuração de banco de dados
```

## 📚 Módulos Disponíveis

### 1. controllerTemplate.psm1

**Função**: `New-ExampleController`

Cria um Controller completo com CRUD de usuários:

- `index()` - Lista todos os usuários
- `show()` - Busca usuário por ID
- `store()` - Cria novo usuário
- `update()` - Atualiza usuário
- `destroy()` - Remove usuário

**Uso**:

```powershell
Import-Module .\controllerTemplate.psm1
New-ExampleController -caminho "C:\meu-projeto" -extensao "js"
```

### 2. modelTemplate.psm1

**Função**: `New-ExampleModel`

Cria um Model de usuário com métodos:

- `findAll()` - Busca todos os usuários
- `findById()` - Busca por ID
- `findByEmail()` - Busca por email
- `create()` - Cria novo usuário
- `update()` - Atualiza dados
- `delete()` - Remove usuário

**Uso**:

```powershell
Import-Module .\modelTemplate.psm1
New-ExampleModel -caminho "C:\meu-projeto" -extensao "ts"
```

### 3. serviceTemplate.psm1

**Função**: `New-ExampleService`

Cria um Service com lógica de negócio:

- `getAllUsers()` - Lista usuários
- `getUserById()` - Busca usuário
- `createUser()` - Cria com validação
- `updateUser()` - Atualiza com validação
- `deleteUser()` - Remove com validação

**Uso**:

```powershell
Import-Module .\serviceTemplate.psm1
New-ExampleService -caminho "C:\meu-projeto" -extensao "js"
```

### 4. middlewareTemplate.psm1

**Função**: `New-ExampleMiddleware`

Cria 4 middlewares:

- `authMiddleware` - Autenticação com token
- `logMiddleware` - Log de requisições
- `validateUser` - Validação de dados
- `errorHandler` - Tratamento global de erros

**Uso**:

```powershell
Import-Module .\middlewareTemplate.psm1
New-ExampleMiddleware -caminho "C:\meu-projeto" -extensao "ts"
```

### 5. databaseTemplate.psm1

**Função**: `New-DatabaseConfig`

Cria configuração para bancos de dados:

- SQLite (desenvolvimento)
- PostgreSQL
- MySQL
- MongoDB

**Uso**:

```powershell
Import-Module .\databaseTemplate.psm1
New-DatabaseConfig -caminho "C:\meu-projeto" -extensao "js"
```

## 🔧 Como Usar

### Opção 1: Usar Módulo Individual

```powershell
Import-Module .\templates\controllerTemplate.psm1
New-ExampleController -caminho "C:\projeto" -extensao "js"
```

### Opção 2: Usar Módulo Agregador

```powershell
Import-Module .\templateModule.psm1

# Cria todos os templates de uma vez
New-ProjectTemplates -caminho "C:\projeto" -extensao "ts"

# Ou use funções individuais
New-ExampleController -caminho "C:\projeto" -extensao "js"
New-ExampleModel -caminho "C:\projeto" -extensao "js"
```

## ✨ Benefícios da Modularização

✅ **Manutenibilidade**: Cada template em seu próprio arquivo  
✅ **Documentação**: Cada módulo tem sua própria documentação  
✅ **Reutilização**: Importe apenas o que precisa  
✅ **Testabilidade**: Mais fácil testar módulos individuais  
✅ **Extensibilidade**: Adicione novos templates facilmente

## 📝 Parâmetros Comuns

Todos os módulos aceitam os mesmos parâmetros:

| Parâmetro  | Tipo   | Obrigatório | Padrão | Descrição                      |
| ---------- | ------ | ----------- | ------ | ------------------------------ |
| `caminho`  | string | Sim         | -      | Caminho raiz do projeto        |
| `extensao` | string | Não         | "js"   | Extensão do arquivo (js ou ts) |

## 🚀 Retorno das Funções

Todas as funções retornam:

- `$true` se o arquivo foi criado com sucesso
- `$false` se houve algum erro

Isso permite validação no fluxo principal:

```powershell
if (New-ExampleController -caminho $projeto -extensao $ext) {
    Write-Host "Controller criado com sucesso!"
} else {
    Write-Host "Erro ao criar Controller"
}
```

## 🔄 Estrutura de Diretórios Esperada

Os módulos esperam que as seguintes pastas existam no projeto:

- `Controllers/` → para Controllers
- `Models/` → para Models
- `Services/` → para Services
- `Middleware/` → para Middlewares
- `Config/` → para configurações

Certifique-se de criar essas pastas antes de usar os templates!
