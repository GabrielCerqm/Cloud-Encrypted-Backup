# Executor opcional para diagnostico; o Agendador chama Backup-Diario.ps1 diretamente.
$ErrorActionPreference = 'Stop'

$pastaLogs = Join-Path $PSScriptRoot 'Logs'
New-Item -ItemType Directory -Path $pastaLogs -Force | Out-Null

$data = Get-Date -Format 'yyyy-MM-dd_HH-mm-ss-fff'
$log = Join-Path $pastaLogs "execucao_$data.log"
$scriptBackup = Join-Path $PSScriptRoot 'Backup-Diario.ps1'

# Captura a saída normal e a saída de erro do processo de backup.
$ErrorActionPreference = 'Continue'

& "$PSHOME\powershell.exe" -NoProfile -NonInteractive -ExecutionPolicy Bypass `
    -File $scriptBackup 2>&1 |
    Tee-Object -FilePath $log -ErrorAction Stop

$codigoSaida = $LASTEXITCODE
"Codigo de saida do processo: $codigoSaida" |
    Tee-Object -FilePath $log -Append -ErrorAction Stop

"Log salvo em: $log"
exit $codigoSaida