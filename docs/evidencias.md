# Índice das evidências do laboratório — v1.0

O conjunto de imagens fornecido para a versão inicial contém **16 capturas numeradas**. A tabela abaixo descreve o que cada uma demonstra. **As imagens binárias ainda não estão incorporadas a este repositório**; sua publicação depende de transferência e revisão de dados visíveis.

| Nº | Evidência | O que demonstra |
|---|---|---|
| 01 | Ferramentas e versões | Versões do Windows, Restic e Rclone. |
| 02 | Estrutura dos dados de origem | Organização de diretórios do laboratório. |
| 03 | Conexão Rclone ao OneDrive | Remoto configurado e consulta à estrutura do repositório. |
| 04 | Repositório armazenado no OneDrive | Localização do repositório na nuvem. |
| 05 | Estrutura do repositório criptografado | Diretórios internos do Restic visualizados no OneDrive. |
| 06 | Objetos criptografados na pasta data | Objetos armazenados sem nomes legíveis de arquivos de origem. |
| 07 | Execução do backup inicial | Execução manual do primeiro backup. |
| 08 | Validação do repositório e snapshots | Consulta à lista de snapshots. |
| 09 | Comparação entre snapshots incrementais | Diferenças entre dois estados do backup. |
| 10 | Estatísticas do repositório | Dados de ocupação e quantidade de itens. |
| 11 | Execução da restauração | Comando de restauração e resultado exibido no terminal. |
| 12 | Estrutura dos dados restaurados | Pastas e arquivos recuperados no destino de teste. |
| 13 | Verificação de integridade do repositório | Execução de `restic check`. |
| 14 | Verificação aprofundada dos dados | Execução de `restic check --read-data`. |
| 15 | Comparação dos hashes SHA256 | Cálculo do hash de um arquivo original e de sua cópia restaurada. |
| 16 | Resultado da validação SHA256 | Resultado da comparação de hashes de arquivos selecionados. |

### Alcance das evidências

As capturas demonstram a execução dos comandos e o comportamento observado no laboratório; não comprovam, isoladamente, políticas de retenção, automação em produção, segurança do armazenamento de credenciais ou recuperação integral de todos os dados.

### Organização prevista dos arquivos

Após uma revisão de confidencialidade, publicar as imagens numeradas em `evidencias/` e substituir esta nota por links diretos para cada figura.
