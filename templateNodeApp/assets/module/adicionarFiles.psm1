# criar pasta app.js
function adicionarFiles() {
    param(
        [string]$caminho,
        [string]$nomeProjeto,
        [string]$nomeArquiApp
    )

    $dadosAppJs = @"
import express from "express";
import dotenv from "dotenv";
import routes from "./routes/router.js";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.get("/", (req, res) => {
    res.send("Hello World!");
});

app.listen(PORT, () => {
    console.log("Server running on port " + PORT);
});

"@

    $readmeMd = @"
# $nomeProjeto

Este projeto foi gerado automaticamente como um template básico de uma aplicação Node.js com Express.

## 🚀 Tecnologias

As seguintes ferramentas foram usadas na construção do projeto:

- [Node.js](https://nodejs.org/en/)
- [Express](https://expressjs.com/)
- [Dotenv](https://www.npmjs.com/package/dotenv)

## 🏁 Como começar

### Pré-requisitos

Antes de começar, você vai precisar ter instalado em sua máquina as seguintes ferramentas:
[Git](https://git-scm.com), [Node.js](https://nodejs.org/en/).

### 🎲 Rodando a aplicação

``` bash
# Instale as dependências
$ npm install

# Execute a aplicação
$ node app.js

"@
    Write-Host "Iniciando criacao dos arquivos . . . `n"
    # Adicionando os arquivos a raiz do projeto
    New-Item -ItemType File -Path "$caminho\$nomeProjeto" -Name $nomeArquiApp -Value $dadosAppJs | Out-Null
    Write-Host "Criado $nomeArquiApp ..." -ForegroundColor White
    New-Item -ItemType File -Path "$caminho\$nomeProjeto" -Name "README.md" -Value $readmeMd | Out-Null
    Write-Host "Criado README.md ...`n" -ForegroundColor White
    Write-Host "Arquivos criados:`n" -ForegroundColor Yellow
    foreach ($arquivo in @($nomeArquiApp, "README.md")) {
        Write-Host " - $arquivo`n" -ForegroundColor White
    }


}

Export-ModuleMember -Function adicionarFiles