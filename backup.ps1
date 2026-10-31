# Backs up the world folders into backups\world-YYYYMMDD-HHmm.zip and keeps the newest 7.
# Safe to run while the server is running: files are copied to a temp folder first
# (session.lock is skipped because the server holds it open).

$ErrorActionPreference = 'Stop'
$root      = $PSScriptRoot
$serverDir = Join-Path $root 'server'
$backupDir = Join-Path $root 'backups'
$keep      = 7

$stamp   = Get-Date -Format 'yyyyMMdd-HHmm'
$staging = Join-Path $env:TEMP "mc-backup-$stamp"
$zip     = Join-Path $backupDir "world-$stamp.zip"

New-Item -ItemType Directory -Force $backupDir | Out-Null

$worlds = Get-ChildItem $serverDir -Directory | Where-Object { Test-Path (Join-Path $_.FullName 'level.dat') }
if (-not $worlds) { Write-Output 'No world folders found.'; exit 1 }

try {
    foreach ($w in $worlds) {
        robocopy $w.FullName (Join-Path $staging $w.Name) /E /R:0 /W:0 /XF session.lock /NFL /NDL /NJH /NJS /NP | Out-Null
        if ($LASTEXITCODE -ge 8) { throw "robocopy failed for $($w.Name) (exit $LASTEXITCODE)" }
    }
    Compress-Archive -Path (Join-Path $staging '*') -DestinationPath $zip -CompressionLevel Optimal
    Write-Output "Backup created: $zip"
}
finally {
    Remove-Item -Recurse -Force $staging -ErrorAction SilentlyContinue
}

Get-ChildItem $backupDir -Filter 'world-*.zip' | Sort-Object LastWriteTime -Descending |
    Select-Object -Skip $keep | Remove-Item -Force
