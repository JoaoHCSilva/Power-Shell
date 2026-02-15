// terminal.js — Funções do terminal de output

/**
 * Adiciona uma nova linha ao terminal de output.
 * @param {string} texto - Texto da linha
 * @param {string} tipo - 'success', 'error', 'info' ou ''
 */
export function adicionarLinhaTerminal(texto, tipo) {
    const terminal = document.getElementById('terminalOutput');
    const linha = document.createElement('div');
    linha.className = `terminal-line ${tipo}`;
    linha.innerHTML = `
        <span class="terminal-prompt">PS &gt;</span>
        <span>${escapeHtml(texto)}</span>
    `;
    terminal.appendChild(linha);

    // Auto-scroll para o final
    terminal.scrollTop = terminal.scrollHeight;
}

/**
 * Escapa HTML para prevenir injeção.
 */
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}
