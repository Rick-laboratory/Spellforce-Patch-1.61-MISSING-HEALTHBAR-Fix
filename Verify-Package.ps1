# Read-only verification of the binaries recorded in SHA256SUMS.
# Run from any directory; paths are resolved relative to this script.
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$entries = @(Get-Content -LiteralPath (Join-Path $PSScriptRoot 'SHA256SUMS'))
if ($entries.Count -eq 0) {
    throw 'The checksum manifest is empty.'
}

$rootPath = [IO.Path]::GetFullPath($PSScriptRoot) + [IO.Path]::DirectorySeparatorChar
foreach ($entry in $entries) {
    if ($entry -notmatch '^([a-fA-F0-9]{64})  (.+)$') {
        throw 'Invalid checksum manifest entry.'
    }

    $expectedHash = $Matches[1]
    $relativePath = $Matches[2]
    $filePath = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot $relativePath))
    if (-not $filePath.StartsWith($rootPath, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Path is outside the package: $relativePath"
    }
    if (-not (Test-Path -LiteralPath $filePath -PathType Leaf)) {
        throw "Missing file: $relativePath"
    }

    $actualHash = (Get-FileHash -LiteralPath $filePath -Algorithm SHA256).Hash
    if ($actualHash -ne $expectedHash) {
        throw "SHA-256 mismatch: $relativePath"
    }
    Write-Output "OK  $relativePath"
}

Write-Output "Verified $($entries.Count) files."
