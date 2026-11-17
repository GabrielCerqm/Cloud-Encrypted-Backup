# Backup automatizado — caminhos de validacao; adapte antes de executar.
# Senha e rclone.conf permanecem locais e nunca devem ser versionados.
$ErrorActionPreference = 'Stop'

$origem = 'C:\Backup-Restic\Dados'
$repositorio = 'rclone:onedrive-lab:Backup-Lab-Restic'
$restic = 'C:\Tools\Restic\restic.exe'
$arquivoSenha = Join-Path $PSScriptRoot 'Config\restic-password.txt'
$configRclone = Join-Path $env:APPDATA 'rclone\rclone.conf'
$pastaLogs = Join-Path $PSScriptRoot 'Logs'

New-Item -ItemType Directory -Path $pastaLogs -Force | Out-Null
$dataExecucao = Get-Date -Format 'yyyy-MM-dd_HH-mm-ss-fff'
$arquivoLog = Join-Path $pastaLogs "backup_$dataExecucao.log"

$codigoRestic = 1
Start-Transcript -Path $arquivoLog | Out-Null

try {
    if (-not (Test-Path -LiteralPath $origem -PathType Container)) {
        throw "Pasta de origem indisponivel: $origem"
    }

    foreach ($arquivo in @($restic, $arquivoSenha, $configRclone)) {
        if (-not (Test-Path -LiteralPath $arquivo -PathType Leaf)) {
            throw "Arquivo necessario indisponivel: $arquivo"
        }
    }

$rclone = (Get-Command rclone.exe -CommandType Application).Source
$pastaRclone = Split-Path -LiteralPath $rclone
$env:Path = "$pastaRclone;$env:Path"
$env:RCLONE_CONFIG = $configRclone

Write-Host "Inicio do backup: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Write-Host "Origem: $origem"
Write-Host "Repositorio: $repositorio"

& $restic -r $repositorio --password-file $arquivoSenha backup $origem
$codigoRestic = $LASTEXITCODE
}
catch {
    Write-Host "Falha na automacao: $($_.Exception.Message)"
}
finally {
    Write-Host "Codigo de saida: $codigoRestic"
    Stop-Transcript | Out-Null
}

exit $codigoRestic
