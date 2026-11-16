# Automação — validação da execução

O ambiente real utiliza automação de backup. Esta página registra a análise das três capturas fornecidas em 16/11/2026, obtidas no ambiente de validação. O script completo ainda não integra a documentação pública da v1.0.

> **Publicação das imagens pendente:** os PNGs ainda não foram anonimizados nem adicionados ao repositório. Os resultados abaixo são uma transcrição resumida das capturas fornecidas, e não substituem os arquivos de evidência.

## Resultados observados

| Captura | Resultado observado | Limitação |
| --- | --- | --- |
| Agendador de Tarefas | Tarefa Backup Diário - Restic; disparador diário às 19:50; última execução em 16/11/2026 às 19:50; resultado 0x0 | A tarefa aparece como **Desabilitado** e o histórico está desabilitado. Não comprova continuidade do agendamento nem, isoladamente, a origem automática do disparo. |
| Ações da tarefa | Ação Iniciar um programa usando Windows PowerShell | Os argumentos estão cortados na captura original; os valores completos foram posteriormente informados pelo responsável e estão documentados abaixo. |
| Log PowerShell | Início às 19:50:02; snapshot ed71d352 salvo; código de saída 0; término da transcrição às 19:50:30 | Comprova o resultado desta execução de backup; não comprova restauração deste snapshot nem todas as condições de execução sem sessão aberta. |

O log registra 8.065 arquivos, 742,395 MiB processados em 25 segundos, nenhum arquivo novo ou alterado e 8.065 arquivos inalterados. Foram adicionados 51,497 KiB ao repositório (10,714 KiB armazenados), com alterações em diretórios. A execução incremental pode gerar um novo snapshot mesmo sem alterações no conteúdo dos arquivos.

Os horários do Agendador e da transcrição são compatíveis com a mesma execução. Os horários acima são reproduzidos conforme exibidos nas capturas; o fuso horário do computador não foi verificado.

## Configuração da ação no Agendador de Tarefas

Na tarefa **Backup Diário - Restic**, em **Ações → Editar**, utilizar a ação **Iniciar um programa** com os campos separados:

**Programa/script** — valor completo informado pelo responsável:

```text
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
```

**Adicionar argumentos** — valor completo informado pelo responsável:

```text
-NoProfile -NonInteractive -ExecutionPolicy Bypass -File "C:\Scripts\Restic\Backup-Diario.ps1"
```

**Iniciar em** — diretório exibido na captura de Editar Ação:

```text
C:\Scripts\Restic
```

Os argumentos pertencem ao campo **Adicionar argumentos**, separados do caminho do executável. Esta transcrição registra os valores fornecidos; não representa um novo teste de execução.

## Comando registrado no log

```powershell
powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -File "C:\Scripts\Restic\Backup-Diario.ps1"
```

Origem de validação: `C:\Backup-Restic\Dados`.

Repositório de validação: `rclone:onedrive-lab:Backup-Lab-Restic`.

O comando executa um script já existente na máquina. Sua presença no log não permite revisar o conteúdo do script, o armazenamento da senha, o tratamento de erros ou o bloqueio de concorrência.

## Capturas necessárias para completar a evidência

1. **Tarefa habilitada e disparador ativo:** mostrar status Pronto, recorrência, próxima execução e a aba Disparadores com o disparador habilitado.
2. **Editar Ação:** os campos completos estão transcritos acima, com programa e argumentos confirmados pelo responsável e diretório de trabalho visível na captura. Uma captura sem truncamento pode complementar o registro.
3. **Execução por horário:** habilitar o histórico e aguardar o próximo disparo; capturar os eventos que identifiquem início pelo agendamento e conclusão, juntamente com o log correspondente. Executar manualmente a tarefa não comprova o disparador por horário.
4. **Restauração do snapshot gerado pela tarefa:** restaurar o snapshot identificado no log em uma pasta separada e comparar hashes SHA-256 de arquivos de teste. A documentação anterior de [restauração](restauracao.md) é complementar, mas não substitui a validação deste snapshot.

Para documentar também execução sem usuário conectado e recuperação após falhas, incluir as abas Geral, Condições e Configurações, com os identificadores pessoais ocultos, e resultados de testes desses cenários. Não declarar essas capacidades apenas pela presença das opções na interface.

## Anonimização dos PNGs antes da publicação

- Log: ocultar os valores de Nome de Usuário, Executar como Usuário e nome do Computador; remover ou ocultar o avatar do aplicativo.
- Agendador: ocultar as demais tarefas e seus detalhes, o autor da tarefa de backup e quaisquer contas ou nomes de computador visíveis.
- Ações: recortar para a janela de propriedades ou ocultar toda a lista de tarefas ao fundo.
- Preservar status Desabilitado, resultado 0x0, datas, horários, comando, totais, snapshot e código de saída. A anonimização não deve modificar o resultado técnico.
- Os caminhos de validação já publicados podem ser mantidos. Não publicar senhas, tokens ou conteúdo de arquivos de credenciais.

As capturas deverão ser inseridas nesta página, junto de cada etapa, após a anonimização e revisão visual.
