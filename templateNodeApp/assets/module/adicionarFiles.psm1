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
import cors from "cors";
import rateLimit from "express-rate-limit";
import routes from "./Routes/router.$extensao";
import { errorHandler } from "./Middleware/middlewares.$extensao";
import logger, { requestLogger } from "./Config/logger.$extensao";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Rate limiting
const limiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutos
    max: 100, // Limite de 100 requisições por IP
    message: 'Muitas requisições deste IP, tente novamente mais tarde.'
});

// Configuracao CORS
const corsOptions = {
    origin: process.env.CORS_ORIGIN || '*',
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
    allowedHeaders: ['Content-Type', 'Authorization'],
    credentials: true
};

// Middlewares globais
app.use(limiter);
app.use(cors(corsOptions));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(requestLogger); // Logger de requisições

// Usar as rotas
app.use(routes);

// Middleware de tratamento de erros (deve ser o último)
app.use(errorHandler);

app.listen(PORT, () => {
    logger.info('========================================');
    logger.info('  Servidor rodando com sucesso!');
    logger.info('========================================');
    logger.info('  URL: http://localhost:' + PORT);
    logger.info('  Ambiente: ' + (process.env.NODE_ENV || 'development'));
    logger.info('========================================');
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
CORS_ORIGIN=http://localhost:5173
NODE_ENV=development
LOG_LEVEL=info

# JWT Secret (MUDE EM PRODUÇÃO!)
JWT_SECRET=seu-secret-super-secreto-mude-isso

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
    
    # Cria o arquivo .env copiando o .env.example
    try {
        Copy-Item -Path "$caminho\$nomeProjeto\.env.example" -Destination "$caminho\$nomeProjeto\.env" -ErrorAction Stop
        Write-Host "Criado .env (cópia de .env.example) ...`n" -ForegroundColor Green
    } catch {
        Write-Host "[AVISO] Não foi possível criar .env automaticamente: $_" -ForegroundColor Yellow
    }
    
    Write-Host "Arquivos criados:`n" -ForegroundColor Yellow
    foreach ($arquivo in @($nomeArquiApp, "README.md", ".env.example", ".env")) {
        Write-Host " - $arquivo`n" -ForegroundColor White
    }


}

Export-ModuleMember -Function adicionarFiles