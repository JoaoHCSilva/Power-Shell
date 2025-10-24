<#
Organizador de arquivos com PowerShell
#>

param(
    [Parameter(Position=0, HelpMessage='Caminho da pasta a organizar. Se vazio, usa a pasta atual.')]
    [string]$Folder = ""
)
$extensaoType = Read-Host "Digite a extensão de arquivo a ser organizada (ex: zip, txt, jpg):"


# Pasta de trabalho (usar a pasta atual ou a passada como parâmetro)
if ($Folder -ne "") {
    $SourceFolder = (Resolve-Path -Path $Folder).Path
} else {
    $SourceFolder = (Get-Location).Path
}

# Nome da pasta de destino
$DestFolderName = "arquivos-$extensaoType"
$DestFolder = Join-Path -Path $SourceFolder -ChildPath $DestFolderName
# Encontra arquivos na pasta atual (não procura em subpastas)
$arquivos = Get-ChildItem -Path $SourceFolder -Filter *'.'$extensaoType -File -ErrorAction SilentlyContinue

# Garante que a pasta de destino exista
if (-not (Test-Path -Path $DestFolder) -and $arquivos) {
    New-Item -Path $DestFolder -ItemType Directory | Out-Null
}

# Função para gerar nome único se já existir arquivo com mesmo nome
function Get-UniquePath {
    param(
        [string]$Folder,
        [string]$FileName
    )
    $base = [System.IO.Path]::GetFileNameWithoutExtension($FileName)
    $ext  = [System.IO.Path]::GetExtension($FileName)
    $dest = Join-Path $Folder $FileName
    $i = 1
    while (Test-Path $dest) {
        $dest = Join-Path $Folder ("{0} ({1}){2}" -f $base, $i, $ext)
        $i++
    }
    return $dest
}

if (!$arquivos -or $arquivos.Count -eq 0) {
    Write-Output "Nenhum arquivo .$extensaoType encontrado em $SourceFolder."
    return
}

# Move cada arquivo .zip para a pasta de destino, evitando sobrescrever
foreach ($arquivo in $arquivos) {
    $uniqueDest = Get-UniquePath -Folder $DestFolder -FileName $arquivo.Name
    Move-Item -Path $arquivo.FullName -Destination $uniqueDest
    Write-Output "Movido: $($arquivo.Name) -> $uniqueDest"
}

#atualiza a quantidade de arquivos movidos informando no nome da pasta
$quantidadeArquivos = (Get-ChildItem -Path $DestFolder -File).count
if( $quantidadeArquivos -gt 0){
    $novoNomePasta = "arquivos-$extensaoType-( $quantidadeArquivos arquivos )"
    # $novoCaminhoPasta = Join-Path -Path $SourceFolder -ChildPath $novoNomePasta
    Rename-Item -Path $DestFolder -NewName $novoNomePasta
}