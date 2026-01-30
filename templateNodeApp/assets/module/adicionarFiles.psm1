# criar pasta app.js
function adicionarFiles() {
    param(
        [string]$caminho,
        [string]$nomeProjeto,
        [string]$nomeArquiApp,
        [string]$extensao
    )


    if ($extensao -eq "ts") {
        $reqERes = "req: any, res: any"
    }
    elseif ($extensao -eq "js") {
        $reqERes = "req, res"
    }

    $dadosAppJs = @"
import express from "express";
import dotenv from "dotenv";
import routes from "./Routes/router.$extensao";
import { errorHandler } from "./Middleware/middlewares.$extensao";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middlewares globais
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Usar as rotas
app.use(routes);

// Middleware de tratamento de erros (deve ser o último)
app.use(errorHandler);

app.listen(PORT, () => {
    console.log("========================================");
    console.log("  Servidor rodando com sucesso!");
    console.log("========================================");
    console.log("  URL: http://localhost:" + PORT);
    console.log("  Ambiente: " + (process.env.NODE_ENV || "development"));
    console.log("========================================");
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

    $envExample = @"
PORT=3000

DB_HOST=SQLITE
# DB_USER=
# DB_PASSWORD=
# DB_NAME=
"@
    Write-Host "Iniciando criacao dos arquivos . . . `n"
    # Adicionando os arquivos a raiz do projeto
    New-Item -ItemType File -Path "$caminho" -Name $nomeArquiApp -Value $dadosAppJs | Out-Null
    Write-Host "Criado $nomeArquiApp ..." -ForegroundColor White
    New-Item -ItemType File -Path "$caminho" -Name "README.md" -Value $readmeMd | Out-Null
    Write-Host "Criado README.md ...`n" -ForegroundColor White
    New-Item -ItemType File -Path "$caminho" -Name ".env.example" -Value $envExample | Out-Null
    Write-Host "Criado .env.example ...`n" -ForegroundColor White
    Write-Host "Arquivos criados:`n" -ForegroundColor Yellow
    foreach ($arquivo in @($nomeArquiApp, "README.md", ".env.example")) {
        Write-Host " - $arquivo`n" -ForegroundColor White
    }


}

Export-ModuleMember -Function adicionarFiles