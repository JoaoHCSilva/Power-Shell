// Ponto de entrada da aplicação - inicia a janela principal com WebView2
// O WebView2 exige que a thread principal seja STA (Single-Threaded Apartment),
// por isso usamos uma classe com [STAThread] em vez de top-level statements.

using System;
using System.Windows.Forms;
using TemplateNodeAppGUI;

namespace TemplateNodeAppGUI
{
    internal static class Program
    {
        /// <summary>
        /// Ponto de entrada principal da aplicação.
        /// [STAThread] é OBRIGATÓRIO para o WebView2 funcionar corretamente.
        /// Sem ele, ocorre o erro: RPC_E_CHANGED_MODE (0x80010106)
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new MainForm());
        }
    }
}
