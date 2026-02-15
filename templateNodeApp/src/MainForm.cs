// MainForm.cs — Formulário principal com WebView2
// Este é o "corpo" da janela da aplicação. Contém o controle WebView2
// que renderiza a interface HTML/CSS/JS.

#nullable enable

using System;
using System.IO;
using System.Text.Json;
using System.Threading.Tasks;
using System.Windows.Forms;
using Microsoft.Web.WebView2.Core;
using Microsoft.Web.WebView2.WinForms;


namespace TemplateNodeAppGUI
{
    /// <summary>
    /// Formulário principal que exibe a interface WebView2.
    /// O WebView2 carrega o index.html e se comunica com o C# via mensagens.
    /// </summary>
    public class MainForm : Form
    {
        // Controle WebView2 que renderiza o HTML dentro da janela
        private WebView2 webView;

        // Ponte para executar o PowerShell
        private PontePowerShell? ponte;

        public MainForm()
        {
            // ------ Configurações da janela ------
            this.Text = "Template Node App - Criador de Projetos";
            this.Width = 1000;
            this.Height = 700;
            this.MinimumSize = new System.Drawing.Size(800, 600);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.BackColor = System.Drawing.Color.FromArgb(18, 18, 24);

            // ------ Configura o WebView2 ------
            webView = new WebView2();
            webView.Dock = DockStyle.Fill; // Ocupa toda a janela
            this.Controls.Add(webView);

            // Inicia o WebView2 quando o formulário carregar
            this.Load += async (sender, args) =>
            {
                // Inicializa o WebView2
                var env = await CoreWebView2Environment.CreateAsync();
                await webView.EnsureCoreWebView2Async(env);

                // Configura aparência - fundo transparente para o tema escuro
                webView.DefaultBackgroundColor = System.Drawing.Color.FromArgb(18, 18, 24);

                // ------ Caminho dos arquivos HTML ------
                // Procura os arquivos da GUI na pasta assets/gui/ relativa ao executável
                string guiPath = FindGuiPath();
                string htmlPath = Path.Combine(guiPath, "HTML", "index.html");

                if (File.Exists(htmlPath))
                {
                    // Mapeia a pasta GUI para um host virtual (https://app.local/)
                    // Isso é OBRIGATÓRIO para que ES Modules (import/export) funcionem,
                    // pois o protocolo file:// bloqueia imports por restrições CORS.
                    webView.CoreWebView2.SetVirtualHostNameToFolderMapping(
                        "app.local",
                        guiPath,
                        CoreWebView2HostResourceAccessKind.Allow
                    );

                    webView.CoreWebView2.Navigate("https://app.local/HTML/index.html");
                }
                else
                {
                    // Se não encontrar, mostra mensagem de erro
                    webView.CoreWebView2.NavigateToString($@"
                        <html>
                        <body style='background:#12121a;color:#fff;font-family:sans-serif;display:flex;align-items:center;justify-content:center;height:100vh;margin:0'>
                            <div style='text-align:center'>
                                <h1>⚠️ Arquivos da GUI não encontrados</h1>
                                <p>Esperado em: {htmlPath.Replace("\\", "/")}</p>
                            </div>
                        </body>
                        </html>");
                }

                // ------ Escuta mensagens da GUI (JavaScript → C#) ------
                webView.CoreWebView2.WebMessageReceived += OnMensagemRecebida;
            };
        }

        /// <summary>
        /// Procura a pasta da GUI tentando diferentes caminhos possíveis.
        /// </summary>
        private string FindGuiPath()
        {
            // Tenta encontrar a pasta gui/ em diferentes localizações
            string[] possiveisCaminhos = {
                Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "assets", "gui"),
                Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "..", "..", "..", "assets", "gui"),
                Path.Combine(Directory.GetCurrentDirectory(), "assets", "gui"),
            };

            foreach (var caminho in possiveisCaminhos)
            {
                string caminhoNormalizado = Path.GetFullPath(caminho);
                if (Directory.Exists(caminhoNormalizado))
                {
                    return caminhoNormalizado;
                }
            }

            // Fallback: retorna o primeiro caminho possível
            return Path.GetFullPath(possiveisCaminhos[0]);
        }

        /// <summary>
        /// Procura a pasta de assets (main.ps1, module/) tentando diferentes caminhos.
        /// </summary>
        private string FindAssetsPath()
        {
            string[] possiveisCaminhos = {
                Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "assets"),
                Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "..", "..", "..", "assets"),
                Path.Combine(Directory.GetCurrentDirectory(), "assets"),
            };

            foreach (var caminho in possiveisCaminhos)
            {
                string caminhoNormalizado = Path.GetFullPath(caminho);
                if (File.Exists(Path.Combine(caminhoNormalizado, "main.ps1")))
                {
                    return caminhoNormalizado;
                }
            }

            return Path.GetFullPath(possiveisCaminhos[0]);
        }

        /// <summary>
        /// Chamado quando a GUI (JavaScript) envia uma mensagem para o C#.
        /// A mensagem é um JSON com a ação e os parâmetros.
        /// </summary>
        private async void OnMensagemRecebida(object? sender, CoreWebView2WebMessageReceivedEventArgs e)
        {
            try
            {
                // Lê o JSON enviado pelo JavaScript
                string jsonStr = e.WebMessageAsJson;
                using var doc = JsonDocument.Parse(jsonStr);
                var root = doc.RootElement;

                string acao = root.GetProperty("acao").GetString() ?? "";

                switch (acao)
                {
                    case "executar":
                        // A GUI pediu para criar um novo projeto
                        string nome = root.GetProperty("nomeProjeto").GetString() ?? "";
                        string caminho = root.GetProperty("caminho").GetString() ?? "";
                        int linguagem = root.GetProperty("linguagem").GetInt32();
                        int template = root.GetProperty("template").GetInt32();

                        await ExecutarCriacao(nome, caminho, linguagem, template);
                        break;

                    case "abrirPasta":
                        // Abre a pasta no Explorer
                        string pasta = root.GetProperty("caminho").GetString() ?? "";
                        if (Directory.Exists(pasta))
                        {
                            System.Diagnostics.Process.Start("explorer.exe", pasta);
                        }
                        break;

                    case "abrirTerminal":
                        // Abre o terminal na pasta do projeto
                        string pastaTerminal = root.GetProperty("caminho").GetString() ?? "";
                        if (Directory.Exists(pastaTerminal))
                        {
                            var psi = new System.Diagnostics.ProcessStartInfo
                            {
                                FileName = "cmd.exe",
                                WorkingDirectory = pastaTerminal,
                                UseShellExecute = true
                            };
                            System.Diagnostics.Process.Start(psi);
                        }
                        break;

                    case "selecionarPasta":
                        // Abre o dialog nativo de seleção de pasta
                        using (var dialog = new FolderBrowserDialog())
                        {
                            dialog.Description = "Selecione a pasta de destino do projeto";
                            dialog.UseDescriptionForTitle = true;
                            dialog.ShowNewFolderButton = true;

                            if (dialog.ShowDialog(this) == DialogResult.OK)
                            {
                                EnviarParaGUI("pastaSelecionada", dialog.SelectedPath);
                            }
                        }
                        break;
                }
            }
            catch (Exception ex)
            {
                EnviarParaGUI("erro", $"Erro interno: {ex.Message}");
            }
        }

        /// <summary>
        /// Executa a criação do projeto usando a PontePowerShell.
        /// </summary>
        private async Task ExecutarCriacao(string nome, string caminho, int linguagem, int template)
        {
            string assetsPath = FindAssetsPath();
            ponte = new PontePowerShell(assetsPath);

            // Quando o PowerShell envia uma linha de output, repassa para a GUI
            ponte.OnOutput += (linha) =>
            {
                // Invoke é necessário porque o evento vem de outra thread
                if (this.InvokeRequired)
                {
                    this.Invoke(() => EnviarParaGUI("output", linha));
                }
                else
                {
                    EnviarParaGUI("output", linha);
                }
            };

            // Quando o script termina
            ponte.OnFinished += (sucesso) =>
            {
                if (this.InvokeRequired)
                {
                    this.Invoke(() =>
                    {
                        string caminhoFinal = Path.Combine(caminho, nome);
                        if (sucesso)
                        {
                            EnviarParaGUI("concluido", caminhoFinal);
                        }
                        else
                        {
                            EnviarParaGUI("erro", "O script encontrou erros durante a execução.");
                        }
                    });
                }
            };

            // Inicia a execução
            EnviarParaGUI("output", "🚀 Iniciando criação do projeto...");
            await ponte.ExecutarAsync(nome, caminho, linguagem, template);
        }

        /// <summary>
        /// Envia uma mensagem do C# para a GUI (JavaScript).
        /// O JavaScript escuta via window.chrome.webview.addEventListener('message', ...)
        /// </summary>
        private void EnviarParaGUI(string tipo, string dados)
        {
            try
            {
                // Escapa caracteres especiais para JSON
                string dadosEscapados = JsonSerializer.Serialize(dados);
                string json = $"{{\"tipo\":\"{tipo}\",\"dados\":{dadosEscapados}}}";
                webView.CoreWebView2.PostWebMessageAsJson(json);
            }
            catch
            {
                // Silencia erros de comunicação (pode acontecer se a janela fechou)
            }
        }
    }
}
