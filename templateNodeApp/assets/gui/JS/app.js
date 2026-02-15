// app.js — Entry point: importa todos os módulos e conecta ao DOM
// Este é o único arquivo referenciado no index.html

import { proximoStep, voltarStep } from './navegacao.js';
import { selecionarOpcao } from './selecao.js';
import { executarProjeto, novoProjeto, abrirPasta, abrirTerminal, finalizarSucesso, finalizarErro, atualizarProgresso } from './execucao.js';
import { limparErro } from './validacao.js';
import { inicializarBridge, registrarHandlers, enviarParaCSharp } from './webview-bridge.js';

// ===== Expõe funções para o HTML (onclick) =====
// Como usamos ES Modules, as funções não ficam acessíveis globalmente por padrão.
// Precisamos anexá-las ao window para que o HTML possa chamá-las via onclick.

window.proximoStep = proximoStep;
window.voltarStep = voltarStep;
window.selecionarOpcao = selecionarOpcao;
window.executarProjeto = executarProjeto;
window.novoProjeto = novoProjeto;
window.abrirPasta = abrirPasta;
window.abrirTerminal = abrirTerminal;

// Abre o dialog nativo de seleção de pasta
window.selecionarPasta = function() {
    enviarParaCSharp({ acao: 'selecionarPasta' });
};

// ===== Inicialização =====

// Registra os handlers do bridge (resolve dependência circular)
registrarHandlers({
    onProgresso: atualizarProgresso,
    onSucesso: finalizarSucesso,
    onErro: finalizarErro
});

// Inicia a ponte WebView2 (escuta mensagens do C#)
inicializarBridge();

// Limpa erros ao digitar nos inputs
document.addEventListener('DOMContentLoaded', () => {
    const inputs = document.querySelectorAll('.form-group input');
    inputs.forEach(input => {
        input.addEventListener('input', () => limparErro(input));

        // Permite avançar com Enter
        input.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') {
                proximoStep(2);
            }
        });
    });
});
