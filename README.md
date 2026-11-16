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
2. [Configuração do Rclone com OneDrive — passo a passo](docs/rclone-onedrive.md)
3. [Restic — configuração, snapshots e operação](docs/restic.md)
4. [Configuração do ambiente e backup](docs/configuracao.md)
5. [Restauração e conferência](docs/restauracao.md)
6. [Segurança e verificações de integridade](docs/seguraca.md)
7. [Índice das 16 evidências](docs/evidencias.md)

### Validação da automação

Consulte a [análise da execução de 16/11/2026 e das evidências pendentes](docs/automacao.md). O log registra snapshot salvo e código de saída 0; a captura do Agendador mostra a tarefa desabilitada. A publicação dos PNGs anonimizados permanece pendente. Este registro complementa a v1.0, sem publicar ainda a implementação completa da automação.

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

## Licença

Este projeto é distribuído sob a **Licença MIT**. Consulte o arquivo [LICENSE](LICENSE) para conhecer os termos de uso, modificação e distribuição.

Copyright (c) 2026 Gabriel Cerqueira.

## Aviso de uso e segurança

Os exemplos e scripts devem ser **adaptados e validados antes de qualquer utilização em produção**. Teste a restauração em ambiente isolado, revise permissões e exclusões e proteja as senhas do Restic e as credenciais do Rclone/OneDrive.

Este projeto é disponibilizado **sem garantia**, conforme os termos da licença MIT. Não publique tokens, senhas, arquivos `rclone.conf` nem dados reais de clientes.
