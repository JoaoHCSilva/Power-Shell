# funcao para criar o arquivo router
function routesModel {
    param (
        [string]$caminho,
        [string]$extensao
    )
    
    Write-Host "Iniciando a criacao do arquivo router.$extensao...`n" -ForegroundColor Yellow
    $dadosRouter = @"
    import express from "express";
    import router from "express.Router()";

    //Suas rotas devem ser adicionadas aqui

    router.get("/", (req, res) => {
        res.send("Rota Inicial");
    });

    export default router;
"@
    
    $arquivoRouter = "$caminho\router.$extensao"
    if (Test-Path -Path $arquivoRouter) {
        Remove-Item -Path $arquivoRouter
    }
    Set-Content -Path $arquivoRouter -Value $dadosRouter
    Write-Host "Arquivo router.$extensao criado com sucesso!`n" -ForegroundColor Green
}

Export-ModuleMember -Function routesModel
