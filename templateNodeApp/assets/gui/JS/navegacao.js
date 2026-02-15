// navegacao.js — Navegação entre steps do wizard

import { estado } from './estado.js';
import { validarStep1 } from './validacao.js';

/**
 * Avança para o próximo step do wizard.
 * @param {number} step - Número do step (1-4)
 */
export function proximoStep(step) {
    if (estado.stepAtual === 1) {
        if (!validarStep1()) return;
    }
    irParaStep(step);
}

/**
 * Volta para o step anterior.
 * @param {number} step - Número do step
 */
export function voltarStep(step) {
    irParaStep(step);
}

/**
 * Navega para um step específico com animação.
 */
export function irParaStep(step) {
    // Esconde o step atual
    const painelAtual = document.getElementById(`step-${estado.stepAtual}`);
    if (painelAtual) painelAtual.classList.remove('active');

    // Mostra o novo step
    const novoPainel = document.getElementById(`step-${step}`);
    if (novoPainel) novoPainel.classList.add('active');

    // Atualiza os indicadores de step
    atualizarIndicadores(step);
    estado.stepAtual = step;
}

/**
 * Atualiza os dots indicadores no topo da página.
 */
function atualizarIndicadores(stepAtivo) {
    const dots = document.querySelectorAll('.step-dot');
    const lines = document.querySelectorAll('.step-line');

    dots.forEach((dot, index) => {
        const numStep = index + 1;
        dot.classList.remove('active', 'completed');

        if (numStep === stepAtivo) {
            dot.classList.add('active');
        } else if (numStep < stepAtivo) {
            dot.classList.add('completed');
        }
    });

    lines.forEach((line, index) => {
        line.classList.remove('completed');
        if (index + 1 < stepAtivo) {
            line.classList.add('completed');
        }
    });
}
