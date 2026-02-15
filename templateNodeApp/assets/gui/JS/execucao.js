// execucao.js — Execução do projeto e progresso

import { estado } from './estado.js';
import { irParaStep } from './navegacao.js';
import { adicionarLinhaTerminal } from './terminal.js';
import { enviarParaCSharp } from './webview-bridge.js';

let progressoAtual = 0;
let progressoInterval = null;

/**
 * Inicia a criação do projeto enviando os dados para o C#.
 */
export function executarProjeto() {
    if (estado.executando) return;
    estado.executando = true;

    // Avança para o step 4 (console)
    irParaStep(4);

    // Limpa o terminal
    const terminal = document.getElementById('terminalOutput');
    terminal.innerHTML = '';
    adicionarLinhaTerminal('Iniciando criação do projeto...', 'info');
    adicionarLinhaTerminal(`Projeto: ${estado.nomeProjeto}`, 'info');
    adicionarLinhaTerminal(`Caminho: ${estado.caminho}`, 'info');
    adicionarLinhaTerminal('---', '');

    // Inicia progresso animado
    iniciarProgresso();

    // Envia mensagem para o C# (via WebView2)
    enviarParaCSharp({
        acao: 'executar',
        nomeProjeto: estado.nomeProjeto,
        caminho: estado.caminho,
        linguagem: estado.linguagem,
        template: estado.template
    });
}

/**
 * Inicia a barra de progresso animada.
 */
function iniciarProgresso() {
    progressoAtual = 0;
    const fill = document.querySelector('.progress-fill');
    const text = document.getElementById('progressText');

    progressoInterval = setInterval(() => {
        if (progressoAtual < 85) {
            progressoAtual += Math.random() * 3;
            fill.style.width = `${Math.min(progressoAtual, 85)}%`;
            text.textContent = `${Math.round(progressoAtual)}%`;
        }
    }, 800);
}

/**
 * Incrementa o progresso com cada linha de output.
 */
export function atualizarProgresso() {
    if (progressoAtual < 85) {
        progressoAtual += 2;
        const fill = document.querySelector('.progress-fill');
        const text = document.getElementById('progressText');
        fill.style.width = `${Math.min(progressoAtual, 85)}%`;
        text.textContent = `${Math.round(progressoAtual)}%`;
    }
}

/**
 * Finaliza o progresso como sucesso.
 */
export function finalizarSucesso() {
    estado.executando = false;
    clearInterval(progressoInterval);

    const fill = document.querySelector('.progress-fill');
    const text = document.getElementById('progressText');
    fill.style.width = '100%';
    text.textContent = 'Concluído!';

    document.getElementById('execucaoTitulo').textContent = '✅ Projeto Criado com Sucesso!';
    document.getElementById('execucaoDesc').textContent = `Seu projeto "${estado.nomeProjeto}" está pronto em ${estado.caminhoFinal}`;

    document.getElementById('conclusionActions').style.display = 'flex';

    adicionarLinhaTerminal('', '');
    adicionarLinhaTerminal('========================================', 'success');
    adicionarLinhaTerminal(`  Projeto ${estado.nomeProjeto} criado com sucesso!`, 'success');
    adicionarLinhaTerminal('========================================', 'success');
}

/**
 * Finaliza o progresso como erro.
 */
export function finalizarErro(mensagem) {
    estado.executando = false;
    clearInterval(progressoInterval);

    const fill = document.querySelector('.progress-fill');
    const text = document.getElementById('progressText');
    fill.style.background = 'linear-gradient(135deg, #ff5a6e, #ff3148)';
    text.textContent = 'Erro!';

    document.getElementById('execucaoTitulo').textContent = '❌ Erro na Criação';
    document.getElementById('execucaoDesc').textContent = mensagem;

    document.getElementById('conclusionActions').style.display = 'flex';

    adicionarLinhaTerminal(mensagem, 'error');
}

/**
 * Volta ao Step 1 para criar um novo projeto.
 */
export function novoProjeto() {
    estado.linguagem = -1;
    estado.template = -1;
    estado.executando = false;
    estado.caminhoFinal = '';

    document.getElementById('conclusionActions').style.display = 'none';
    document.getElementById('execucaoTitulo').textContent = '⏳ Criando Projeto...';
    document.getElementById('execucaoDesc').textContent = 'Aguarde enquanto o projeto é configurado.';
    document.querySelector('.progress-fill').style.width = '0%';
    document.querySelector('.progress-fill').style.background = 'var(--accent-gradient)';
    document.getElementById('progressText').textContent = 'Executando...';

    document.querySelectorAll('.option-card').forEach(card => card.classList.remove('selected'));
    document.getElementById('btnStep2').disabled = true;
    document.getElementById('btnExecutar').disabled = true;

    irParaStep(1);
}

/**
 * Abre a pasta do projeto no Explorer.
 */
export function abrirPasta() {
    enviarParaCSharp({
        acao: 'abrirPasta',
        caminho: estado.caminhoFinal
    });
}

/**
 * Abre o terminal na pasta do projeto.
 */
export function abrirTerminal() {
    enviarParaCSharp({
        acao: 'abrirTerminal',
        caminho: estado.caminhoFinal
    });
}
