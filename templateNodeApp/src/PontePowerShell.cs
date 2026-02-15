// PontePowerShell.cs — Ponte entre a GUI (C#) e o script PowerShell (main.ps1)
// Executa o script como um processo externo e captura a saída em tempo real.

#nullable enable

using System;
using System.Diagnostics;
using System.IO;
using System.Threading.Tasks;

namespace TemplateNodeAppGUI
{
    /// <summary>
    /// Classe responsável por executar scripts PowerShell e capturar a saída.
    /// Funciona como a "ponte" entre a interface gráfica e o script main.ps1.
    /// </summary>
    public class PontePowerShell
    {
        // Evento disparado quando o PowerShell envia uma nova linha de texto
        public event Action<string>? OnOutput;

        // Evento disparado quando o script termina (true = sucesso, false = erro)
        public event Action<bool>? OnFinished;

        // Caminho da pasta onde estão os assets (main.ps1, module/, etc.)
        private readonly string _assetsPath;

        public PontePowerShell(string assetsPath)
        {
            _assetsPath = assetsPath;
        }

        /// <summary>
        /// Executa o script main.ps1 de forma modificada — em vez de usar Read-Host interativo,
        /// passamos os parâmetros como argumentos para um script wrapper que chama as funções.
        /// </summary>
        /// <param name="nomeProjeto">Nome do projeto a criar</param>
        /// <param name="caminho">Caminho onde criar o projeto</param>
        /// <param name="linguagem">Índice da linguagem: 0 = JavaScript, 1 = TypeScript</param>
        /// <param name="template">Índice do template Vite (0-10)</param>
        public async Task ExecutarAsync(string nomeProjeto, string caminho, int linguagem, int template)
        {
            // Monta o script PowerShell inline que importa os módulos e executa as funções
            // Isso evita o problema de Read-Host que pede input interativo
            string scriptWrapper = GerarScriptWrapper(nomeProjeto, caminho, linguagem, template);

            await Task.Run(() =>
            {
                try
                {
                    // Configura o processo PowerShell
                    var startInfo = new ProcessStartInfo
                    {
                        FileName = "powershell.exe",
                        Arguments = $"-NoProfile -ExecutionPolicy Bypass -Command \"{EscapeForCmd(scriptWrapper)}\"",
                        UseShellExecute = false,          // Necessário para capturar saída
                        RedirectStandardOutput = true,    // Captura stdout
                        RedirectStandardError = true,     // Captura stderr
                        CreateNoWindow = true,            // Não abre janela do console
                        WorkingDirectory = _assetsPath
                    };

                    using var processo = new Process();
                    processo.StartInfo = startInfo;

                    // Captura cada linha de output em tempo real
                    processo.OutputDataReceived += (sender, e) =>
                    {
                        if (e.Data != null)
                        {
                            OnOutput?.Invoke(e.Data);
                        }
                    };

                    // Captura erros também
                    processo.ErrorDataReceived += (sender, e) =>
                    {
                        if (e.Data != null)
                        {
                            OnOutput?.Invoke($"[ERRO] {e.Data}");
                        }
                    };

                    processo.Start();
                    processo.BeginOutputReadLine();
                    processo.BeginErrorReadLine();
                    processo.WaitForExit();

                    // Informa se terminou com sucesso ou com erro
                    bool sucesso = processo.ExitCode == 0;
                    OnFinished?.Invoke(sucesso);
                }
                catch (Exception ex)
                {
                    OnOutput?.Invoke($"[ERRO FATAL] {ex.Message}");
                    OnFinished?.Invoke(false);
                }
            });
        }

        /// <summary>
        /// Gera um script PowerShell que executa as mesmas ações do main.ps1,
        /// mas sem pedir input interativo (Read-Host). Os valores vêm da GUI.
        /// </summary>
        private string GerarScriptWrapper(string nomeProjeto, string caminho, int linguagem, int template)
        {
            string scriptPath = Path.Combine(_assetsPath, "main.ps1").Replace("\\", "\\\\");
            string modulePath = Path.Combine(_assetsPath, "module").Replace("\\", "\\\\");

            // Lista de templates Vite disponíveis (mesma ordem do main.ps1)
            string[] templates = { "vanilla", "vanilla-ts", "vue", "vue-ts", "react", "react-ts",
                                   "preact", "lit", "svelte", "solid", "qwik" };
            string[] extensoes = { "js", "ts" };

            string templateEscolhido = template >= 0 && template < templates.Length ? templates[template] : "vanilla";
            string extensaoEscolhida = linguagem >= 0 && linguagem < extensoes.Length ? extensoes[linguagem] : "js";

            // Script PowerShell que replica a lógica do main.ps1 usando os parâmetros da GUI
            return $@"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

$scriptDir = '{modulePath.Replace("\\\\", "\\")}'
$modulePath = $scriptDir

Import-Module ""$modulePath\\viteInstal.psm1"" -Force
Import-Module ""$modulePath\\adicionarFiles.psm1"" -Force
Import-Module ""$modulePath\\dependenciasModule.psm1"" -Force
Import-Module ""$modulePath\\routesModel.psm1"" -Force
Import-Module ""$modulePath\\templateModule.psm1"" -Force
Import-Module ""$modulePath\\packageScriptsModule.psm1"" -Force

$nomeProjeto = '{nomeProjeto}'
$caminho = '{caminho}'
$extensaoEscolhida = '{extensaoEscolhida}'
$templateEscolhido = '{templateEscolhido}'

Write-Host 'Verificando pre-requisitos...' -ForegroundColor Cyan

$nodeCmd = Get-Command node -ErrorAction SilentlyContinue
if (-not $nodeCmd) {{
    Write-Host '[ERRO] Node.js nao esta instalado.' -ForegroundColor Red
    exit 1
}}
$nodeVersion = (node --version) -replace 'v', ''
Write-Host ""  [OK] Node.js v$nodeVersion"" -ForegroundColor Green

$npmCmd = Get-Command npm -ErrorAction SilentlyContinue
if (-not $npmCmd) {{
    Write-Host '[ERRO] npm nao esta instalado.' -ForegroundColor Red
    exit 1
}}
$npmVersion = npm --version
Write-Host ""  [OK] npm v$npmVersion"" -ForegroundColor Green

if (-not (Test-Path -Path $caminho)) {{
    New-Item -Path $caminho -ItemType Directory -Force | Out-Null
    Write-Host ""[OK] Caminho criado: $caminho"" -ForegroundColor Green
}}

$caminhoCompleto = Join-Path $caminho $nomeProjeto
if (Test-Path -Path $caminhoCompleto) {{
    Write-Host ""[ERRO] O projeto ja existe em: $caminhoCompleto"" -ForegroundColor Red
    exit 1
}}

New-Item -Path $caminho -Name $nomeProjeto -ItemType Directory -ErrorAction Stop | Out-Null
Write-Host ""Projeto criado em: $caminhoCompleto"" -ForegroundColor Green

$pastas = @('Controllers', 'Models', 'Views', 'Routes', 'Services', 'Helpers', 'Config', 'Database', 'Middleware')
foreach ($pasta in $pastas) {{
    New-Item -Path ""$caminho\\$nomeProjeto"" -Name ""$pasta"" -ItemType Directory -ErrorAction Stop | Out-Null
    Write-Host ""- $pasta"" -ForegroundColor White
}}

Set-Location -Path ""$caminho\\$nomeProjeto"" -ErrorAction Stop

$nomeArquiApp = ""app.$extensaoEscolhida""
adicionarFiles -caminho $caminho -nomeProjeto $nomeProjeto -nomeArquiApp $nomeArquiApp -extensao $extensaoEscolhida

$gitignoreContent = 'node_modules/
.env
dist/
build/
*.log
.DS_Store
temp/
coverage/
.vscode/
.idea/'
New-Item -Path ""$caminho\\$nomeProjeto\\.gitignore"" -ItemType File -Value $gitignoreContent -Force | Out-Null
Write-Host 'Criado .gitignore' -ForegroundColor Green

routesModel -caminho 'Routes' -extensao $extensaoEscolhida

$caminhoAtual = Get-Location
New-ProjectTemplates -caminho $caminhoAtual -extensao $extensaoEscolhida

instalarVite $nomeProjeto $templateEscolhido
Write-Host 'Vite instalado com sucesso!' -ForegroundColor Green

installDependencies
Write-Host 'Dependencias instaladas!' -ForegroundColor Green

Add-BackendScripts -caminho (Get-Location) -extensao $extensaoEscolhida

Write-Host ''
Write-Host '========================================'
Write-Host ""  Projeto $nomeProjeto criado com sucesso!""
Write-Host '========================================'
Write-Host ""Localizacao: $caminhoCompleto""
Write-Host ""Linguagem: $extensaoEscolhida""
Write-Host ""Template: $templateEscolhido""
";
        }

        /// <summary>
        /// Escapa caracteres especiais para passar o script via linha de comando.
        /// </summary>
        private static string EscapeForCmd(string script)
        {
            return script
                .Replace("\"", "\\\"")
                .Replace("\r\n", " ; ")
                .Replace("\n", " ; ");
        }
    }
}
