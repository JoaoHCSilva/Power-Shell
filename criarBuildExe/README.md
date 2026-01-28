## Estrutura de Arquivos

- `dist/`: Contém o executável final após o build.
- `build/`: Arquivos temporários utilizados durante o processo de compilação.
- `*.spec`: Arquivo de configuração gerado pelo PyInstaller para customizações futuras.

## Notas

- Utilize a flag `--noconsole` se o seu script possuir uma interface gráfica (GUI) e você não desejar que o terminal abra em segundo plano.
- Utilize a flag `--icon="icone.ico"` para adicionar um ícone personalizado ao seu executável.
- Se o comando `pyinstaller` não for reconhecido diretamente no PowerShell, tente utilizar: `python -m PyInstaller --onefile seu_script.py`.
