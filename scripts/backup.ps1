# Cloud Encrypted Backup - exemplo didático v1.0
# Execução MANUAL. Não implementa automação, agendamento nem retenção.
# Antes de executar, configure o remoto onedrive-lab e uma senha segura do Restic.
# O repositório deve ter sido inicializado previamente com "restic init".
# Não inclua credenciais ou dados reais neste arquivo.

$ErrorActionPreference = 'Stop'
$env:RESTIC_REPOSITORY = 'rclone:onedrive-lab:Backup-Lab-Restic'
$origem = 'C:\Backup-Restic\Dados'

if (-not (Test-Path -LiteralPath $origem -PathType Container)) {
    throw "Diretorio de origem nao encontrado: $origem"
}

restic backup $origem
if ($LASTEXITCODE -ne 0) {
    throw "Falha no comando de backup do Restic (codigo $LASTEXITCODE)"
}

restic snapshots
if ($LASTEXITCODE -ne 0) {
    throw "Falha na consulta de snapshots (codigo $LASTEXITCODE)"
}
