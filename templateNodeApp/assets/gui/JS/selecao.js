// selecao.js — Seleção de opções (linguagem e template)

import { estado } from './estado.js';

/**
 * Seleciona uma opção (linguagem ou template).
 * @param {HTMLElement} elemento - O card clicado
 * @param {string} tipo - 'linguagem' ou 'template'
 */
export function selecionarOpcao(elemento, tipo) {
    // Remove seleção anterior do mesmo grupo
    const container = elemento.parentElement;
    container.querySelectorAll('.option-card').forEach(card => {
        card.classList.remove('selected');
    });

    // Marca o novo selecionado
    elemento.classList.add('selected');
    const valor = parseInt(elemento.dataset.value);

    if (tipo === 'linguagem') {
        estado.linguagem = valor;
        document.getElementById('btnStep2').disabled = false;
    } else if (tipo === 'template') {
        estado.template = valor;
        document.getElementById('btnExecutar').disabled = false;
    }
}
