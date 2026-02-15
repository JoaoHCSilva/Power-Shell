# Iniciar Projeto PowerShell

Script utilitário para criar rapidamente a estrutura base de um novo projeto PowerShell.

## Descrição

Este script automatiza a criação de novos projetos PowerShell, gerando uma estrutura de arquivos padronizada e templates prontos para uso.

## Arquivos Criados

Ao executar o script, os seguintes arquivos serão criados:

| Arquivo      | Descrição                                        |
| ------------ | ------------------------------------------------ |
| `README.md`  | Documentação do projeto com estrutura de tópicos |
| `main.ps1`   | Script principal com menu interativo de exemplo  |
| `build.bat`  | Arquivo batch para execução rápida do script     |
| `.gitignore` | Configuração para ignorar `.env` e `assets/`     |

## Como Usar

### Opção 1: Via PowerShell

```powershell
.\criar-projeto.ps1
```

### Opção 2: Via Clique Duplo

Clique duas vezes no arquivo `build.bat` (quando disponível)

## Fluxo do Script

1. **Nome do projeto**: Digite o nome do seu novo projeto
2. **Caminho**: Escolha onde criar o projeto (ou use o diretório atual)
3. **Criação**: Os arquivos são gerados automaticamente
4. **Abertura**: Opção de abrir a pasta do projeto no Explorer

## Estrutura Gerada

```
MeuProjeto/
├── main.ps1       # Script principal (template com menu)
├── build.bat      # Executável para rodar o script
├── README.md      # Documentação inicial
└── .gitignore     # Ignora .env e assets/
```

## Template do main.ps1

O `main.ps1` gerado inclui:

- Cabeçalho com informações do projeto
- Função de menu interativo
- Estrutura de funções organizadas
- Loop principal com switch de opções
- Tratamento de erros básico

## Autor

João Henrique

## Licença

MIT License
