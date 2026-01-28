# 📦 PS2EXE - Guia Completo

> Converta seus scripts PowerShell (.ps1) em executáveis Windows (.exe)

---

## 📋 Índice

1. [Instalação](#-instalação)
2. [Uso Básico](#-uso-básico)
3. [Parâmetros Disponíveis](#-parâmetros-disponíveis)
4. [Exemplos Práticos](#-exemplos-práticos)
5. [Dicas e Boas Práticas](#-dicas-e-boas-práticas)
6. [Solução de Problemas](#-solução-de-problemas)
7. [Recursos Adicionais](#-recursos-adicionais)

---

## 🔧 Instalação

### Instalar o módulo PS2EXE

```powershell
# Instalar para o usuário atual (recomendado)
Install-Module -Name ps2exe -Scope CurrentUser

# Ou instalar para todos os usuários (requer admin)
Install-Module -Name ps2exe -Scope AllUsers
```

### Verificar instalação

```powershell
Get-Module -Name ps2exe -ListAvailable
```

### Atualizar o módulo

```powershell
Update-Module -Name ps2exe
```

---

## 🚀 Uso Básico

### Comando mínimo

```powershell
Invoke-PS2EXE -InputFile ".\meuScript.ps1" -OutputFile ".\meuScript.exe"
```

### Usando alias (atalho)

```powershell
ps2exe .\meuScript.ps1 .\meuScript.exe
```

---

## ⚙️ Parâmetros Disponíveis

### Parâmetros Essenciais

| Parâmetro     | Descrição                           | Exemplo                      |
| ------------- | ----------------------------------- | ---------------------------- |
| `-InputFile`  | Caminho do script .ps1 de entrada   | `-InputFile ".\script.ps1"`  |
| `-OutputFile` | Caminho do executável .exe de saída | `-OutputFile ".\script.exe"` |

### Parâmetros de Interface

| Parâmetro    | Descrição                                          | Exemplo      |
| ------------ | -------------------------------------------------- | ------------ |
| `-NoConsole` | Cria aplicação Windows GUI (sem janela de console) | `-NoConsole` |
| `-NoOutput`  | Suprime a saída do script                          | `-NoOutput`  |
| `-NoError`   | Suprime mensagens de erro                          | `-NoError`   |

### Parâmetros de Informações do Executável

| Parâmetro      | Descrição                | Exemplo                         |
| -------------- | ------------------------ | ------------------------------- |
| `-Title`       | Título do executável     | `-Title "Minha Aplicação"`      |
| `-Description` | Descrição do executável  | `-Description "Descrição aqui"` |
| `-Company`     | Nome da empresa          | `-Company "Minha Empresa"`      |
| `-Product`     | Nome do produto          | `-Product "Meu Produto"`        |
| `-Copyright`   | Informações de copyright | `-Copyright "© 2026"`           |
| `-Version`     | Versão do executável     | `-Version "1.0.0.0"`            |

### Parâmetros de Ícone

| Parâmetro   | Descrição                               | Exemplo                   |
| ----------- | --------------------------------------- | ------------------------- |
| `-IconFile` | Arquivo de ícone .ico para o executável | `-IconFile ".\icone.ico"` |

### Parâmetros Avançados

| Parâmetro       | Descrição                                     | Exemplo         |
| --------------- | --------------------------------------------- | --------------- |
| `-RequireAdmin` | Requer privilégios de administrador           | `-RequireAdmin` |
| `-SupportOS`    | Usa funções específicas do Windows            | `-SupportOS`    |
| `-Virtualize`   | Habilita virtualização de arquivos e registro | `-Virtualize`   |
| `-LongPaths`    | Habilita caminhos longos (> 260 caracteres)   | `-LongPaths`    |
| `-x86`          | Compila para 32 bits                          | `-x86`          |
| `-x64`          | Compila para 64 bits                          | `-x64`          |
| `-Nested`       | Permite scripts aninhados                     | `-Nested`       |

### Parâmetros de Configuração

| Parâmetro       | Descrição                                 | Exemplo                      |
| --------------- | ----------------------------------------- | ---------------------------- |
| `-ConfigFile`   | Arquivo de configuração para o executável | `-ConfigFile ".\config.xml"` |
| `-NoConfigFile` | Não gerar arquivo de configuração         | `-NoConfigFile`              |

---

## 📝 Exemplos Práticos

### 1. Conversão Simples

```powershell
Invoke-PS2EXE -InputFile ".\backup.ps1" -OutputFile ".\backup.exe"
```

### 2. Aplicação GUI (sem console)

```powershell
Invoke-PS2EXE -InputFile ".\app.ps1" -OutputFile ".\app.exe" -NoConsole
```

### 3. Com ícone personalizado

```powershell
Invoke-PS2EXE -InputFile ".\meuApp.ps1" -OutputFile ".\meuApp.exe" -IconFile ".\icone.ico"
```

### 4. Executável que requer admin

```powershell
Invoke-PS2EXE -InputFile ".\instalador.ps1" -OutputFile ".\instalador.exe" -RequireAdmin
```

### 5. Completo com metadados

```powershell
Invoke-PS2EXE `
    -InputFile ".\meuScript.ps1" `
    -OutputFile ".\meuScript.exe" `
    -Title "Minha Aplicação" `
    -Description "Uma aplicação incrível" `
    -Company "Minha Empresa" `
    -Product "Meu Produto" `
    -Copyright "© 2026 Todos os direitos reservados" `
    -Version "1.0.0.0" `
    -IconFile ".\icone.ico" `
    -NoConsole
```

### 6. Script de Build automatizado

Crie um arquivo `build.ps1`:

```powershell
# build.ps1 - Script de compilação
param(
    [string]$ScriptPath = ".\app.ps1",
    [string]$OutputPath = ".\dist\app.exe",
    [string]$IconPath = ".\assets\icon.ico"
)

# Cria pasta de saída se não existir
$distFolder = Split-Path -Parent $OutputPath
if (!(Test-Path $distFolder)) {
    New-Item -ItemType Directory -Path $distFolder -Force
}

# Compila o script
$params = @{
    InputFile    = $ScriptPath
    OutputFile   = $OutputPath
    Title        = "Minha App"
    Version      = "1.0.0.0"
    NoConsole    = $true
}

# Adiciona ícone se existir
if (Test-Path $IconPath) {
    $params.IconFile = $IconPath
}

Invoke-PS2EXE @params

Write-Host "✅ Build concluído: $OutputPath" -ForegroundColor Green
```

---

## 💡 Dicas e Boas Práticas

### 1. Organize seus projetos   

```
📁 MeuProjeto/
├── 📁 src/
│   └── 📄 main.ps1
├── 📁 assets/
│   └── 🖼️ icon.ico
├── 📁 dist/
│   └── ⚙️ app.exe
├── 📄 build.ps1
└── 📄 README.md
```

### 2. Use caminhos relativos

```powershell
# ❌ Evite caminhos absolutos
$caminho = "C:\Users\joaoh\MeuProjeto\arquivo.txt"

# ✅ Use caminhos relativos ou variáveis de ambiente
$caminho = Join-Path $PSScriptRoot "arquivo.txt"
$caminho = "$env:USERPROFILE\MeuProjeto\arquivo.txt"
```

### 3. Use `$PSScriptRoot` para arquivos relativos

```powershell
# Obtém o diretório onde o script/exe está localizado
$pastaRaiz = $PSScriptRoot

# Caminho para arquivo de configuração junto ao .exe
$configPath = Join-Path $PSScriptRoot "config.json"
```

### 4. Teste antes de compilar

```powershell
# Execute o .ps1 primeiro para garantir que funciona
.\meuScript.ps1

# Depois compile
Invoke-PS2EXE -InputFile ".\meuScript.ps1" -OutputFile ".\meuScript.exe"

# Por fim, teste o .exe
.\meuScript.exe
```

### 5. Adicione tratamento de erros

```powershell
try {
    # Seu código aqui
    Write-Host "Executando..."
}
catch {
    Write-Error "Erro: $_"
    Read-Host "Pressione Enter para sair"
    exit 1
}
```

### 6. Mantenha uma versão de build

```powershell
# Atualize a versão a cada release
$version = "1.2.3.4"  # Major.Minor.Build.Revision

Invoke-PS2EXE -InputFile ".\app.ps1" -OutputFile ".\app-v$version.exe" -Version $version
```

---

## 🔧 Solução de Problemas

### Erro: "Execution Policy"

```powershell
# Verifique a política atual
Get-ExecutionPolicy

# Altere para permitir scripts locais
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Erro: "Module not found"

```powershell
# Reinstale o módulo
Remove-Module ps2exe -Force -ErrorAction SilentlyContinue
Install-Module -Name ps2exe -Scope CurrentUser -Force
```

### Antivírus bloqueia o .exe

- Isso é comum porque o PS2EXE cria executáveis não assinados
- Adicione o executável às exclusões do antivírus
- Ou use `-SupportOS` para melhor compatibilidade

### Script funciona, mas .exe não

1. Use caminhos absolutos ou `$PSScriptRoot`
2. Verifique se todas as dependências estão acessíveis
3. Execute o .exe como administrador se necessário

### Janela fecha muito rápido

Adicione ao final do script:

```powershell
Read-Host "Pressione Enter para sair"
```

Ou use:

```powershell
Start-Sleep -Seconds 5  # Espera 5 segundos
```

---

## 📚 Recursos Adicionais

### Links Úteis

- 📦 **PowerShell Gallery**: [https://www.powershellgallery.com/packages/ps2exe](https://www.powershellgallery.com/packages/ps2exe)
- 📖 **GitHub Oficial**: [https://github.com/MScholtes/PS2EXE](https://github.com/MScholtes/PS2EXE)
- 📝 **Documentação**: `Get-Help Invoke-PS2EXE -Full`

### Comando de Ajuda

```powershell
# Ver todos os parâmetros disponíveis
Get-Help Invoke-PS2EXE -Full

# Ou ver exemplos
Get-Help Invoke-PS2EXE -Examples
```

---

## 🎯 Resumo Rápido (Cheat Sheet)

```powershell
# Instalação
Install-Module -Name ps2exe -Scope CurrentUser

# Conversão básica
Invoke-PS2EXE -InputFile ".\script.ps1" -OutputFile ".\script.exe"

# Sem console (GUI)
Invoke-PS2EXE -InputFile ".\script.ps1" -OutputFile ".\script.exe" -NoConsole

# Com ícone
Invoke-PS2EXE -InputFile ".\script.ps1" -OutputFile ".\script.exe" -IconFile ".\icon.ico"

# Requer admin
Invoke-PS2EXE -InputFile ".\script.ps1" -OutputFile ".\script.exe" -RequireAdmin

# Completo
Invoke-PS2EXE -InputFile ".\script.ps1" -OutputFile ".\script.exe" `
    -Title "App" -Version "1.0.0.0" -IconFile ".\icon.ico" -NoConsole
```

---

> 📅 **Criado em**: Janeiro 2026  
> 📝 **Autor**: Documentação gerada para projetos PowerShell  
> ⭐ **Dica**: Salve este arquivo como referência para seus projetos futuros!
