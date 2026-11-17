# Restic — configuração e operação do backup criptografado

Guia reproduzível da **v1.0** em Windows 11, PowerShell e OneDrive via Rclone. Este documento explica o funcionamento dos comandos; a [configuração e backup manual](configuracao.md) apresenta as evidências correspondentes.

> **Atenção:** os caminhos `C:\Backup-Restic\...` e o remoto `onedrive-lab` são exemplos do ambiente de validação. Não aponte os comandos para o repositório de produção sem revisar origem, destino e permissões.

## 1. Papel do Restic na arquitetura

O Restic lê arquivos da origem, cria snapshots incrementais e armazena o conteúdo **criptografado**. O backend `rclone:` permite guardar o repositório no OneDrive configurado pelo Rclone.

Antes de prosseguir, instale as ferramentas em [Instalação](instalacao.md) e configure o remoto conforme [Rclone + OneDrive](rclone-onedrive.md).

## 2. Preparar os dados de exemplo

```powershell
New-Item -ItemType Directory -Force "C:\Backup-Restic\Dados" | Out-Null
New-Item -ItemType Directory -Force "C:\Backup-Restic\Restauracao" | Out-Null
"Arquivo de validação do backup" | Set-Content "C:\Backup-Restic\Dados\exemplo.txt"
```

O diretório `Dados` é a **origem**; `Restauracao` fica separado para evitar sobrescrever arquivos originais.

## 3. Apontar o Restic para o repositório

```powershell
$env:RESTIC_REPOSITORY = "rclone:onedrive-lab:Backup-Lab-Restic"
```

- `rclone:`: backend utilizado pelo Restic.
- `onedrive-lab:`: remote criado via `rclone config`.
- `Backup-Lab-Restic`: pasta do repositório no OneDrive.

A variável acima vale **somente para a sessão atual** do PowerShell. Ao abrir outro terminal, defina-a novamente ou passe `-r` explicitamente nos comandos.

Verifique a configuração do Rclone sem mostrar credenciais:

```powershell
rclone listremotes
rclone lsf "onedrive-lab:"
```

## 4. Senha do repositório e inicialização

Para execução manual, **prefira informar a senha quando o Restic solicitar**. Guarde-a em um gerenciador seguro e mantenha uma cópia de recuperação protegida. Perder a senha pode tornar o backup irrecuperável.

**Apenas para um repositório novo:**

```powershell
restic init
```

O comando cria os metadados do repositório criptografado e solicita confirmação da senha.

**Para um repositório existente, não execute `init` novamente:**

```powershell
restic snapshots
```

Se `init` retornar `config file already exists`, isso indica que já há um repositório no destino. Não exclua ou sobrescreva seus dados.

Para a [rotina automatizada](automacao.md), pode-se configurar um arquivo de senha **fora do Git**, protegido por permissões de arquivo, e informar sua localização via `RESTIC_PASSWORD_FILE`; não armazene a senha nos scripts ou no README.

## 5. Primeiro backup

```powershell
restic backup "C:\Backup-Restic\Dados" --verbose
restic snapshots
```

- `backup` lê a origem e salva seu estado no repositório.
- `--verbose` exibe detalhes da execução; revise a saída antes de capturá-la.
- `snapshots` lista identificadores e datas dos pontos de recuperação.

Confira a conclusão sem erros e avalie mensagens de arquivos ignorados por falta de permissão. Um backup pode terminar sem proteger todos os dados pretendidos se não houver acesso à origem.

## 6. Backup incremental

Altere o arquivo de teste ou adicione outro arquivo e execute:

```powershell
"Segunda versão" | Add-Content "C:\Backup-Restic\Dados\exemplo.txt"
restic backup "C:\Backup-Restic\Dados"
restic snapshots
```

O Restic produz um **novo snapshot** e reutiliza conteúdo já existente no repositório sempre que possível. Isso reduz a quantidade de dados novos armazenados, sem eliminar os pontos de recuperação anteriores.

Para comparar dois snapshots:

```powershell
restic diff <ID_SNAPSHOT_ANTERIOR> <ID_SNAPSHOT_NOVO>
```

Substitua os marcadores pelos IDs exibidos em `restic snapshots` (não copie os caracteres `<` e `>` literalmente).

## 7. Estatísticas e consumo de armazenamento

```powershell
restic stats
restic stats --mode raw-data
```

O primeiro comando resume o tamanho lógico dos dados restauráveis segundo o modo padrão; `raw-data` informa dados brutos armazenados segundo o modo de cálculo do Restic. **Não compare diretamente os números como se fossem a mesma métrica**: snapshots retidos, deduplicação, compactação e metadados influenciam os valores.

## 8. Validar a integridade

```powershell
restic check
restic check --read-data
```

- `check`: valida estrutura e metadados.
- `check --read-data`: lê e valida também os dados armazenados, podendo demorar e consumir tráfego em nuvem.

Uma verificação íntegra **não substitui um teste de restauração**.

## 9. Restaurar para uma pasta separada

```powershell
restic restore latest --target "C:\Backup-Restic\Restauracao"
```

Para restaurar um snapshot específico:

```powershell
restic snapshots
restic restore <ID_SNAPSHOT> --target "C:\Backup-Restic\Restauracao"
```

Verifique os arquivos restaurados no destino; os caminhos originais podem aparecer como subpastas. Veja a [validação com SHA-256](restauracao.md) para comparar arquivos selecionados com a origem.

## 10. Erros e cuidados frequentes

| Situação | Orientação |
| --- | --- |
| `Please specify repository location` | Redefina `$env:RESTIC_REPOSITORY` no PowerShell atual ou use `-r`. |
| `config file already exists` ao executar `init` | Já existe um repositório. Utilize a senha original e `restic snapshots`. |
| `rclone` não reconhecido | Abra novo terminal e confirme `rclone version`. |
| `access denied` em arquivos da origem | Revise permissões; confirme quais arquivos realmente foram protegidos. |
| Restauração sem alguns arquivos | Confira o snapshot selecionado, filtros, permissões e mensagens de erro. |

**Segurança:** não versione `rclone.conf`, senhas, tokens, dados de clientes, logs com dados pessoais nem arquivos de repositório. Não execute comandos destrutivos de retenção (`forget --prune`) sem política validada; esse tema fica para uma versão posterior.

## Referências oficiais

- [Restic — documentação](https://restic.readthedocs.io/en/stable/)
- [Restic — preparação do repositório](https://restic.readthedocs.io/en/stable/030_preparing_a_new_repo.html)
- [Restic — backup](https://restic.readthedocs.io/en/stable/040_backup.html)
- [Restic — restauração](https://restic.readthedocs.io/en/stable/050_restore.html)
