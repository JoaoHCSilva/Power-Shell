# funcao para criar o arquivo router
function routesModel {
    param (
        [string]$caminho,
        [string]$extensao
    )
    if($extensao -eq "ts") {
        $reqERes = "req: Any, res: Any"
    }
    elseif($extensao -eq "js") {
        $reqERes = "req, res"
    }

    Write-Host "Iniciando a criacao do arquivo router.$extensao...`n" -ForegroundColor Yellow
    $dadosRouter = @"
    import router from "express.Router()";

    //Suas rotas devem ser adicionadas aqui

    router.get("/", ($reqERes) => {
        res.send("Rota Inicial");
    });

    export default router;
"@
    
    $arquivoRouter = "router.$extensao"
    $caminhoAtual = Get-Location
    $caminhoArquivoFinal = "$caminhoAtual\$caminho"
    if (Test-Path -Path "$caminhoArquivoFinal\$arquivoRouter") {
        Remove-Item -Path "$caminhoArquivoFinal\$arquivoRouter"
    }
    New-Item -Path "$caminhoArquivoFinal\$arquivoRouter" -ItemType File -Value $dadosRouter
    Write-Host "Arquivo router.$extensao criado com sucesso!`n" -ForegroundColor Green
}

Export-ModuleMember -Function routesModel
