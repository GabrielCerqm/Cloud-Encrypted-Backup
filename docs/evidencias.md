# Índice das evidências do laboratório — v1.0

O conjunto de imagens fornecido para a versão inicial contém **16 capturas numeradas**. A tabela abaixo descreve o que cada uma demonstra. As capturas aparecem nas páginas de cada procedimento. Alguns trechos foram ocultados para preservar informações pessoais.

| Nº | Evidência | O que demonstra |
|---|---|---|
| 01 | [Ferramentas e versões](assets/instalacao/01-ferramentas-e-versoes.png) | Versões do Windows, Restic e Rclone. |
| 02 | [Estrutura dos dados de origem](assets/configuracao/02-dados-de-origem.png) | Organização de diretórios do laboratório. |
| 03 | [Conexão Rclone ao OneDrive](assets/configuracao/03-rclone-onedrive.png) | Remoto configurado e consulta à estrutura do repositório. |
| 04 | [Repositório armazenado no OneDrive](assets/configuracao/04-pasta-do-repositorio.png) | Localização do repositório na nuvem. |
| 05 | [Estrutura do repositório criptografado](assets/seguraca/05-estrutura-criptografada.png) | Diretórios internos do Restic visualizados no OneDrive. |
| 06 | [Objetos criptografados na pasta data](assets/seguraca/06-pasta-data.png) | Subpastas que organizam os packs do Restic. |
| 07 | [Execução do backup inicial](assets/configuracao/07-backup-inicial.png) | Execução manual do primeiro backup. |
| 08 | [Validação do repositório e snapshots](assets/configuracao/08-snapshots.png) | Consulta à lista de snapshots. |
| 09 | [Comparação entre snapshots incrementais](assets/configuracao/09-comparacao-incremental.png) | Diferenças entre dois estados do backup. |
| 10 | [Estatísticas do repositório](assets/configuracao/10-estatisticas.png) | Tamanho lógico e quantidade de itens em modo `restore-size`. |
| 11 | [Execução da restauração](assets/restauracao/11-execucao-da-restauracao.png) | Comando de restauração e resultado exibido no terminal. |
| 12 | [Estrutura dos dados restaurados](assets/restauracao/12-dados-restaurados.png) | Pastas e arquivos recuperados no destino de teste. |
| 13 | [Verificação de integridade do repositório](assets/seguraca/13-restic-check.png) | Execução de `restic check`. |
| 14 | [Verificação aprofundada dos dados](assets/seguraca/14-restic-check-read-data.png) | Execução de `restic check --read-data`. |
| 15 | [Comparação dos hashes SHA256](assets/restauracao/15-comparacao-sha256.png) | Cálculo do hash de um arquivo original e de sua cópia restaurada. |
| 16 | [Resultado da validação SHA256](assets/restauracao/16-resultado-sha256.png) | Validação em lote: 8.065 arquivos idênticos no conjunto comparado. |

### Alcance das evidências

As capturas demonstram a execução dos comandos e o comportamento observado no laboratório; não comprovam, isoladamente, políticas de retenção, automação em produção, segurança do armazenamento de credenciais ou recuperação integral de todos os dados.


## Automação no Windows 11 — v1.1

| Captura | Registro |
| --- | --- |
| [Disparadores](assets/automacao/01-disparadores.png) | Diário às 19:50, habilitado. |
| [Ações](assets/automacao/02-acoes.png) | PowerShell e diretório de trabalho; argumentos completos transcritos no guia. |
| [Log](assets/automacao/03-log.png) | Snapshot ed71d352 salvo; saída 0. |
| [Geral](assets/automacao/04-geral-windows11.png) | Opções de conta e execução. |
| [Configurações](assets/automacao/05-configuracoes-windows11.png) | Agendamento perdido e prevenção de nova instância. |

As cinco imagens foram editadas por IA para anonimização. Os estados descritos foram conferidos nas capturas originais da conversa. Consulte o [guia de automação](automacao.md) para o alcance da evidência e os limites dos scripts.
