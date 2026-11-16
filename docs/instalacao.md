# Instalação do Restic e Rclone no Windows 11

Este guia integra a **v1.0 — Backup criptografado e restauração**. As instalações são executadas no PowerShell; nenhum segredo deve ser publicado.

## 1. Pré-requisitos

- Windows 11 com PowerShell e acesso à internet.
- WinGet instalado (verifique com `winget --version`).
- Conta Microsoft com OneDrive e permissão de autenticação.
- Pasta com arquivos de teste **sem dados reais ou confidenciais**.

## 2. Instalar o Restic

Abra o PowerShell e execute:

```powershell
winget install --id restic.restic -e
```

O Restic é responsável por **criptografar**, deduplicar, registrar snapshots e restaurar o backup. Confirme a instalação:

```powershell
restic version
```

Se `restic` não for reconhecido, feche e abra o PowerShell.

## 3. Instalar o Rclone

```powershell
winget install --id Rclone.Rclone -e
rclone version
```

O Rclone fornece a conexão com o OneDrive. **Neste projeto, ele não realiza a criptografia dos arquivos: isso é responsabilidade do Restic.**

## 4. Verificação conjunta

```powershell
winget list --id restic.restic -e
winget list --id Rclone.Rclone -e
restic version
rclone version
```

As versões usadas nas evidências foram Restic **0.19.1** e Rclone **1.76.0**. Elas não são requisitos mínimos e os pacotes disponíveis podem mudar.

![Ferramentas e versões](assets/instalacao/01-ferramentas-e-versoes.png)

## 5. Próximos passos

1. [Conectar o Rclone ao OneDrive](rclone-onedrive.md), usando `rclone config`.
2. [Configurar o Restic e inicializar o repositório](restic.md).
3. [Executar e comparar backups](configuracao.md).
4. [Restaurar arquivos](restauracao.md) e [verificar integridade](seguraca.md).

## Referências oficiais

- [Restic — documentação](https://restic.readthedocs.io/en/stable/)
- [Rclone — instalação](https://rclone.org/install/)
