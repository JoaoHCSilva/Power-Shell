# criar pasta app.js
function appJS() {
    param (
        [Parameter(Mandatory = $True)]
        [string]$caminho
    )

    # 1 - testa se o caminho existe
    if ((Test-Path -Path $caminho) -and !(Test-Path -Path "$caminho\app.js")) {
        # 2 - cria o arquivo app.js 
        $caminhoAppJs = New-Item -Path "$caminho\app.js" -ItemType File
    }
    else { 
        # 3 - exibe erro
        if (!(Test-Path -Path $caminho)) {
            Write-Error "O caminho $caminho não existe."
        }
        else {
            Write-Error "O arquivo app.js já existe."
        }
    }
    # 4 - cria o arquivo app.js
    $dadosAppJs = @"
import express from "express";
import dotenv from "dotenv";

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

    # 5 - escreve no arquivo app.js
    Set-Content -Path $caminhoAppJs -Value $dadosAppJs
}

$caminho = Read-Host "Digite o caminho: Exemplo: C:\Users\joaoh\PowerShell\"
# 6 - chama a função
appJS -caminho $caminho
