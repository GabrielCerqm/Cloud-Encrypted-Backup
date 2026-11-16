# Configuração do Rclone com Microsoft OneDrive — Windows 11

Este procedimento complementa a **v1.0 — Backup criptografado e restauração**. O Rclone conecta o Windows ao OneDrive; a **criptografia do conteúdo e a criação dos snapshots são realizadas pelo Restic**, não pelo Rclone neste projeto.

> Os nomes `onedrive-lab` e `Backup-Lab-Restic` representam o ambiente de validação documentado no repositório. Substitua-os por nomes adequados ao seu ambiente. A configuração abaixo é reproduzível, mas as telas e opções variam conforme a versão do Rclone e a conta Microsoft.

## 1. Instalar e confirmar o Rclone

Abra o PowerShell no Windows 11:

```powershell
winget install --id Rclone.Rclone -e
rclone version
```

Se o comando `rclone` não for reconhecido, abra um novo terminal e teste novamente.

## 2. Criar a conexão (remote)

Execute:

```powershell
rclone config
```

No menu interativo:

1. Selecione `n` (**New remote**).
2. Em **name**, digite `onedrive-lab`.
3. Em **Storage**, escolha **Microsoft OneDrive** (normalmente identificado por `onedrive`; o número da opção varia por versão).
4. Em **client_id** e **client_secret**, deixe em branco para usar as credenciais padrão do Rclone, salvo se sua organização exigir um aplicativo próprio.
5. Em **region**, selecione a região apropriada para a conta; para uma conta Microsoft comum, normalmente `global`.
6. Em **Edit advanced config?**, selecione `n` caso não precise de opções avançadas.
7. Em **Use web browser to automatically authenticate rclone with remote?**, selecione `y` se houver navegador disponível no computador.

## 3. Autorizar a conta Microsoft

O Rclone normalmente inicia um fluxo OAuth no navegador. Entre na **conta Microsoft autorizada** e conclua o consentimento solicitado. Em organizações com restrições de aplicativos, pode ser necessária aprovação do administrador.

Volte ao terminal. Se aparecer uma seleção de unidade, escolha a unidade OneDrive correta. Confirme as informações de unidade exibidas e finalize salvando a configuração (`y`, quando solicitado).

**Importante:** não capture nem publique a URL completa de autorização, códigos OAuth, tokens, e-mails, identificadores de unidade nem o conteúdo do arquivo `rclone.conf`.

> Se o navegador não abrir, o fluxo sem navegador exige etapas adicionais; consulte a documentação oficial do Rclone em [Microsoft OneDrive](https://rclone.org/onedrive/) em vez de copiar tokens para o repositório.

## 4. Verificar se o remote foi criado

```powershell
rclone listremotes
```

A saída deve conter o nome do remoto, por exemplo:

```text
onedrive-lab:
```

Teste a listagem da raiz do OneDrive:

```powershell
rclone lsf "onedrive-lab:"
```

Uma saída vazia pode significar que a raiz não contém arquivos. Para verificar a conexão com mais detalhes:

```powershell
rclone about "onedrive-lab:"
```

O comando `about` pode não ser suportado por todos os tipos de unidade/conta. Não é necessário publicar a saída, pois ela pode revelar dados da conta.

## 5. Criar a pasta do repositório de backup

No ambiente de validação:

```powershell
rclone mkdir "onedrive-lab:Backup-Lab-Restic"
rclone lsf "onedrive-lab:"
```

A pasta no OneDrive servirá de destino ao **repositório Restic**. Criá-la não inicializa o repositório nem criptografa dados.

## 6. Integrar o remote ao Restic

Confirme que o Restic está instalado (`restic version`) e defina o repositório no PowerShell:

```powershell
$env:RESTIC_REPOSITORY = "rclone:onedrive-lab:Backup-Lab-Restic"
```

O prefixo `rclone:` indica ao Restic que deve utilizar o backend do Rclone. O restante indica o remote e a pasta no OneDrive.

**Somente se o repositório ainda não existir:**

```powershell
restic init
```

O Restic solicitará uma senha: mantenha-a segura e fora do Git. Se o repositório já existir, **não reinicialize**; configure o acesso à senha original e confira:

```powershell
restic snapshots
```

Para executar um backup e verificar a restauração, siga [Configuração e backup manual](configuracao.md) e [Restauração e conferência](restauracao.md).

## 7. Proteção da configuração

O Rclone grava dados de configuração localmente, incluindo informações de autenticação OAuth. Para descobrir **somente o caminho** do arquivo:

```powershell
rclone config file
```

Não execute comandos que exibam tokens em prints públicos. Não envie `rclone.conf` ao GitHub. Proteja a conta com MFA, restrinja o acesso ao perfil do Windows e preserve as credenciais e a senha do Restic em locais seguros e separados.

O Rclone **não substitui a senha do Restic**: para restaurar os dados em outra máquina, será necessário configurar o acesso ao remoto e dispor da senha correta do repositório.

## Evidência disponível

A captura já publicada em [Configuração e backup manual](configuracao.md#1-configurar-o-rclone) demonstra a conexão com o OneDrive. As etapas interativas acima são **instruções de reprodução**, e não prints de uma instalação que tenha sido registrada integralmente.
