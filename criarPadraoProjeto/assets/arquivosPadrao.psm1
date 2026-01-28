#criar arquivos padrao
function criarArquivosPadrao(){
    param(
        [string]$nomeProjeto
    )
    # gitignore
    $gitignore = @"
.vscode
assets
dist
test
.env
"@
    $mainPs1 = @"
#seu arquivo main.ps1
function suaFuncao(){
Write-Host "Sua funcao"
  }  
"@

    $buildBatch = @"
@echo off
#lembre-se o build será realizada no arquivo build.ps1 localizado na raiz do projeto
powershell.exe -ExecutionPolicy Bypass -File ..\build.ps1
echo Build concluido com sucesso!
pause
"@
    $readmeMd = @"
# Nome do Projeto

Uma breve descrição sobre o que o projeto faz e qual o seu objetivo principal.

## 🚀 Funcionalidades

- [x] Funcionalidade 1
- [x] Funcionalidade 2
- [ ] Funcionalidade em desenvolvimento

## 🛠️ Tecnologias Utilizadas

- [Tecnologia 1](https://link-para-site.com)
- [Tecnologia 2](https://link-para-site.com)

## 🏁 Como começar

### Pré-requisitos

Liste o que é necessário para rodar o projeto (ex: Node.js, Docker, Python).

### Instalação

1. Clone o repositório:
git clone https://github.com/usuario/projeto.git

2. Entre no diretório:
cd projeto

3. Instale as dependências:


npm install # ou o comando correspondente à sua linguagem

## 📖 Como usar

Explique brevemente como utilizar o projeto ou forneça exemplos de uso.

npm start

## 🤝 Contribuição

1. Faça um **fork** do projeto.
2. Crie uma nova **branch** com suas alterações: git checkout -b minha-feature
3. Salve suas alterações e crie uma mensagem de **commit**: git commit -m "feat: Adicionada nova funcionalidade"
4. Envie suas alterações: git push origin minha-feature
5. Abra um **Pull Request**.

## 📝 Licença

Este projeto está sob a licença [MIT](LICENSE).

---
Feito com ❤️ por [Seu Nome](https://github.com/seu-usuario)

"@

    Write-Host "Criando arquivos padrao...`n" -ForegroundColor Green
    # Populando os dados do arquivo
    Set-Content -Path "$nomeProjeto\.gitignore" -Value $gitignore
    Set-Content -Path "$nomeProjeto\assets\main.ps1" -Value $mainPs1
    Set-Content -Path "$nomeProjeto\build.bat" -Value $buildBatch
    Set-Content -Path "$nomeProjeto\README.md" -Value $readmeMd
}

Export-ModuleMember -Function criarArquivosPadrao
