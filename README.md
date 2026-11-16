# Cloud Encrypted Backup — Restic + Rclone + OneDrive

![Versão](https://img.shields.io/badge/vers%C3%A3o-1.0-blue) ![Status](https://img.shields.io/badge/status-em%20produ%C3%A7%C3%A3o-brightgreen)

Solução de **backup criptografado e incremental em nuvem utilizada em ambiente real**, com Windows 11, **Restic**, **Rclone** e **Microsoft OneDrive**. O projeto operacional possui uma rotina automatizada de backup; a documentação pública é publicada por etapas e esta primeira versão aborda a configuração, a execução do backup, os snapshots, a restauração e os testes de integridade.

> **Escopo da documentação v1.0:** implantação de backup criptografado e restauração, com comandos reproduzíveis manualmente. **A automação já utilizada no ambiente real será documentada em versão posterior**; sua implementação não está incluída nos arquivos públicos desta versão. Não confundir o escopo da documentação com as funcionalidades já existentes no ambiente.

## Objetivos

- Armazenar backups cifrados no OneDrive, mantendo os dados protegidos antes do envio.
- Demonstrar snapshots e backups incrementais com deduplicação.
- Restaurar dados em um diretório separado da origem.
- Verificar a integridade do repositório e comparar hashes SHA-256 de arquivos.
- Documentar os procedimentos com capturas de um ambiente de teste, sem expor informações do ambiente de produção.

## Tecnologias

| Componente | Utilização |
| --- | --- |
| Windows 11 / PowerShell | Ambiente e execução de comandos |
| Restic 0.19.1 | Backup, criptografia, snapshots e restauração |
| Rclone 1.76.0 | Integração com OneDrive |
| Microsoft OneDrive | Armazenamento do repositório |

Versões observadas nas capturas de validação; não representam requisitos mínimos.

## Arquitetura

```mermaid
flowchart LR
    A["Arquivos de origem"] --> B["Restic: criptografia, snapshots, deduplicação"]
    B --> C["Rclone"]
    C --> D["OneDrive"]
    D --> E["Repositório criptografado"]
    E --> F["Restauração via Restic"]
```

**Ambiente de validação utilizado nas evidências:** origem `C:\Backup-Restic\Dados`; repositório `rclone:onedrive-lab:Backup-Lab-Restic`; restauração `C:\Backup-Restic\Restauracao`. Estes são caminhos de teste usados para demonstrar a solução real sem divulgar os caminhos ou as credenciais de produção.

## Documentação da v1.0

1. [Instalação e versões](docs/instalacao.md)
2. [Configuração do ambiente e backup](docs/configuracao.md)
3. [Restauração e conferência](docs/restauracao.md)
4. [Segurança e verificações de integridade](docs/seguraca.md)
5. [Índice das 16 evidências](docs/evidencias.md)

### Comandos essenciais (reprodução em ambiente de teste)

Após configurar o remoto do Rclone e a senha do repositório de forma segura:

```powershell
$env:RESTIC_REPOSITORY = "rclone:onedrive-lab:Backup-Lab-Restic"
restic backup "C:\Backup-Restic\Dados"
restic snapshots
restic stats
restic check
restic restore latest --target "C:\Backup-Restic\Restauracao"
```

A senha do Restic é indispensável para os comandos; **não** a inclua em scripts versionados, capturas ou histórico do terminal. Consulte [segurança](docs/seguraca.md).

## Resultados registrados

As evidências coletadas no ambiente de validação cobrem: identificação das ferramentas, conexão com OneDrive, estrutura criptografada, backup inicial, múltiplos snapshots, comparação incremental, estatísticas, restauração, `restic check`, `restic check --read-data` e verificação SHA-256. A comparação de hashes documenta a igualdade dos arquivos selecionados para teste, **não** uma auditoria exaustiva de todos os arquivos.

## Evolução planejada

- **v1.0 — Backup criptografado e restauração:** escopo descrito neste documento.
- **Versão futura da documentação — Automação:** publicação do fluxo PowerShell, agendamento, logs, tratamento de erros e, quando comprovada, política de retenção. A automação operacional existente será apresentada em versão separada, após revisão de segurança.

## Observações de segurança

Este repositório **não** deve conter dados de clientes, arquivos originais de backup, tokens OAuth, `rclone.conf`, senhas, chaves ou identificadores sensíveis. As evidências utilizam um ambiente de validação com caminhos de exemplo; evite compartilhar capturas não revisadas.

**Licença:** não definida neste momento.
