# Builds the resource pack the server sends to players, by merging two packs into one zip
# (server.properties takes only one pack URL):
#   - NMinimap's pack: server\plugins\NMinimap\built-pack.zip, rebuilt by the plugin at every server start
#   - NoMod Shaders:   resourcepack\sources\NoModShaders-0.6.0_resourcepack.zip
#
# Usage, from the project folder:
#   powershell -NoProfile -ExecutionPolicy Bypass -File resourcepack\build-pack.ps1 -Version 2
# Writes resourcepack\minimap-shaders-v2.zip and prints the two server.properties lines for it.
# Use a new version number every time: GitHub keeps serving a cached copy of a file for a few
# minutes, and a stale copy would not match the SHA-1, so friends would fail to load the pack.

param([Parameter(Mandatory = $true)][int]$Version)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$here     = $PSScriptRoot
$root     = Split-Path $here -Parent
$sources  = Join-Path $here 'sources'
$nminimap = Join-Path $root 'server\plugins\NMinimap\built-pack.zip'
$nomod    = Join-Path $sources 'NoModShaders-0.6.0_resourcepack.zip'
$out      = Join-Path $here "minimap-shaders-v$Version.zip"
$extras   = 'CREDITS.txt', 'LICENSE-NoModShaders.txt', 'LICENSE-NMinimap-GPL-3.0.txt'

if (Test-Path $out) { throw "$out already exists. Use a new -Version number." }
foreach ($f in @($nminimap, $nomod) + ($extras | ForEach-Object { Join-Path $sources $_ })) {
    if (-not (Test-Path $f)) { throw "Missing input file: $f" }
}

$utf8 = New-Object Text.UTF8Encoding($false)

# Reads every file of a zip into an ordered name -> bytes table (folder entries are skipped).
function Read-Zip([string]$path) {
    $files = [ordered]@{}
    $zip = [IO.Compression.ZipFile]::OpenRead($path)
    try {
        foreach ($e in $zip.Entries) {
            if ($e.FullName.EndsWith('/')) { continue }
            $ms = New-Object IO.MemoryStream
            $s = $e.Open(); $s.CopyTo($ms); $s.Close()
            $files[$e.FullName.Replace('\', '/')] = $ms.ToArray()
        }
    } finally { $zip.Dispose() }
    return $files
}

function Read-Json([byte[]]$bytes) {
    return ($utf8.GetString($bytes).TrimStart([char]0xFEFF) | ConvertFrom-Json)
}

$a = Read-Zip $nminimap
$b = Read-Zip $nomod
$metaA = Read-Json $a['pack.mcmeta']
$metaB = Read-Json $b['pack.mcmeta']
$skip = 'pack.mcmeta', 'pack.png'

# A file that is in both packs (also counting NMinimap's version-specific overlay folders, which
# replace base files) would silently drop one pack's version. Stop instead, so it can be merged by hand.
$overlayDirs = @($metaA.overlays.entries | ForEach-Object { $_.directory })
$aPaths = @{}
foreach ($p in $a.Keys) {
    if ($skip -contains $p) { continue }
    $base = $p
    foreach ($d in $overlayDirs) { if ($p.StartsWith("$d/")) { $base = $p.Substring($d.Length + 1) } }
    $aPaths[$base] = $p
}
$clash = @($b.Keys | Where-Object { ($skip -notcontains $_) -and $aPaths.ContainsKey($_) })
if ($clash.Count) { throw ("Both packs contain these files, merge them by hand first:`n  " + ($clash -join "`n  ")) }

# The merged pack claims only the versions NoMod Shaders supports (it is made for 26.3 only),
# and keeps NMinimap's overlays so its version-specific minimap shader still gets picked.
$meta = [ordered]@{
    pack     = [ordered]@{
        description = 'Minimap (NMinimap) + shader look (NoMod Shaders) for this server. See CREDITS.txt'
        min_format  = $metaB.pack.min_format
        max_format  = $metaB.pack.max_format
    }
    overlays = $metaA.overlays
}
$metaJson = $meta | ConvertTo-Json -Depth 10

$fs = [IO.File]::Open($out, [IO.FileMode]::CreateNew)
$zip = New-Object IO.Compression.ZipArchive($fs, [IO.Compression.ZipArchiveMode]::Create)
try {
    function Add-Entry([string]$name, [byte[]]$bytes) {
        $e = $zip.CreateEntry($name, [IO.Compression.CompressionLevel]::Optimal)
        $s = $e.Open(); $s.Write($bytes, 0, $bytes.Length); $s.Close()
    }
    Add-Entry 'pack.mcmeta' $utf8.GetBytes($metaJson)
    foreach ($p in $a.Keys) { if ($skip -notcontains $p) { Add-Entry $p $a[$p] } }
    foreach ($p in $b.Keys) { if ($skip -notcontains $p) { Add-Entry $p $b[$p] } }
    foreach ($x in $extras) { Add-Entry $x ([IO.File]::ReadAllBytes((Join-Path $sources $x))) }
} finally {
    $zip.Dispose()
    $fs.Dispose()
}

# Read the result back: the zip must open and its pack.mcmeta must parse.
$check = Read-Zip $out
$null = Read-Json $check['pack.mcmeta']
$sha1 = (Get-FileHash -Algorithm SHA1 $out).Hash.ToLower()

Write-Output "Built $out ($((Get-Item $out).Length) bytes, $($check.Count) files)"
Write-Output 'Put these two lines in server\server.properties after the zip is pushed to GitHub:'
Write-Output "resource-pack=https://raw.githubusercontent.com/iwgh08/minecraft_sever/main/resourcepack/minimap-shaders-v$Version.zip"
Write-Output "resource-pack-sha1=$sha1"
