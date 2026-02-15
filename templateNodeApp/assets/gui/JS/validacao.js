// validacao.js — Validação de inputs do formulário

import { estado } from './estado.js';

/**
 * Valida os campos do Step 1 (nome e caminho).
 * @returns {boolean} true se válido
 */
export function validarStep1() {
    let valido = true;
    const nomeInput = document.getElementById('nomeProjeto');
    const caminhoInput = document.getElementById('caminhoProjeto');
    const nome = nomeInput.value.trim();
    const caminho = caminhoInput.value.trim();

    // Limpa erros anteriores
    limparErro(nomeInput);
    limparErro(caminhoInput);

    // Validação do nome
    if (!nome) {
        mostrarErro(nomeInput, 'O nome do projeto é obrigatório');
        valido = false;
    } else if (/[<>:"/\\|?*]/.test(nome)) {
        mostrarErro(nomeInput, 'Nome contém caracteres inválidos: < > : " / \\ | ? *');
        valido = false;
    }

    // Validação do caminho
    if (!caminho) {
        mostrarErro(caminhoInput, 'O caminho de destino é obrigatório');
        valido = false;
    }

    if (valido) {
        estado.nomeProjeto = nome;
        estado.caminho = caminho;
    }

    return valido;
}

/**
 * Mostra mensagem de erro em um input.
 */
export function mostrarErro(input, mensagem) {
    input.classList.add('error');
    const hint = input.parentElement.querySelector('.input-hint');
    if (hint) {
        hint.textContent = mensagem;
        hint.classList.add('input-error');
    }
}

/**
 * Limpa mensagem de erro de um input.
 */
export function limparErro(input) {
    input.classList.remove('error');
    const hint = input.parentElement.querySelector('.input-hint');
    if (hint) {
        hint.classList.remove('input-error');
        // Restaura a dica original
        if (input.id === 'nomeProjeto') {
            hint.textContent = 'Use letras, números, hífens ou underscores';
        } else {
            hint.textContent = 'A pasta será criada dentro deste caminho';
        }
    }
}
