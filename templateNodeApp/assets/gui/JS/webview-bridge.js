// webview-bridge.js — Comunicação com C# via WebView2

import { estado } from './estado.js';
import { adicionarLinhaTerminal } from './terminal.js';

// Callbacks registrados pelo app.js para evitar dependência circular
let _handlers = {
    onProgresso: () => {},
    onSucesso: () => {},
    onErro: () => {}
};

/**
 * Registra os handlers de eventos recebidos do C#.
 * Chamado pelo app.js após importar os módulos necessários.
 */
export function registrarHandlers(handlers) {
    _handlers = { ..._handlers, ...handlers };
}

/**
 * Envia uma mensagem JSON do JavaScript para o C#.
 * O C# recebe via evento WebMessageReceived.
 */
export function enviarParaCSharp(dados) {
    if (window.chrome && window.chrome.webview) {
        window.chrome.webview.postMessage(dados);
    } else {
        // Modo de desenvolvimento (rodando no navegador normal)
        console.log('[DEV MODE] Mensagem para C#:', dados);
        simularExecucao();
    }
}

/**
 * Inicializa o listener de mensagens vindas do C#.
 * Deve ser chamado uma vez no carregamento.
 */
export function inicializarBridge() {
    if (window.chrome && window.chrome.webview) {
        window.chrome.webview.addEventListener('message', function(event) {
            const msg = event.data;

            switch (msg.tipo) {
                case 'output':
                    let tipo = '';
                    if (msg.dados.includes('[OK]') || msg.dados.includes('sucesso') || msg.dados.includes('Criado')) {
                        tipo = 'success';
                    } else if (msg.dados.includes('[ERRO]') || msg.dados.includes('erro')) {
                        tipo = 'error';
                    } else if (msg.dados.includes('Verificando') || msg.dados.includes('Instalando') || msg.dados.includes('🚀')) {
                        tipo = 'info';
                    }
                    adicionarLinhaTerminal(msg.dados, tipo);
                    _handlers.onProgresso();
                    break;

                case 'concluido':
                    estado.caminhoFinal = msg.dados;
                    _handlers.onSucesso();
                    break;

                case 'erro':
                    _handlers.onErro(msg.dados);
                    break;

                case 'pastaSelecionada':
                    // Resposta do dialog de seleção de pasta
                    const inputCaminho = document.getElementById('caminhoProjeto');
                    if (inputCaminho && msg.dados) {
                        inputCaminho.value = msg.dados;
                        inputCaminho.dispatchEvent(new Event('input'));
                    }
                    break;
            }
        });
    }
}

/**
 * Simula a execução do PowerShell (apenas para testes no navegador).
 */
function simularExecucao() {
    const mensagens = [
        { texto: 'Verificando pré-requisitos...', tipo: 'info', delay: 500 },
        { texto: '  [OK] Node.js v20.11.0', tipo: 'success', delay: 1000 },
        { texto: '  [OK] npm v10.2.0', tipo: 'success', delay: 1500 },
        { texto: 'Projeto criado em: C:\\projetos\\meu-app', tipo: 'success', delay: 2000 },
        { texto: '- Controllers', tipo: '', delay: 2200 },
        { texto: '- Models', tipo: '', delay: 2400 },
        { texto: '- Views', tipo: '', delay: 2600 },
        { texto: '- Routes', tipo: '', delay: 2800 },
        { texto: '- Services', tipo: '', delay: 3000 },
        { texto: 'Criado .gitignore', tipo: 'success', delay: 3500 },
        { texto: 'Instalando Vite...', tipo: 'info', delay: 4000 },
        { texto: 'Vite instalado com sucesso!', tipo: 'success', delay: 6000 },
        { texto: 'Instalando dependências...', tipo: 'info', delay: 6500 },
        { texto: 'Dependências instaladas!', tipo: 'success', delay: 9000 },
    ];

    mensagens.forEach(msg => {
        setTimeout(() => {
            adicionarLinhaTerminal(msg.texto, msg.tipo);
            _handlers.onProgresso();
        }, msg.delay);
    });

    setTimeout(() => {
        estado.caminhoFinal = `${estado.caminho}\\${estado.nomeProjeto}`;
        _handlers.onSucesso();
    }, 10000);
}
