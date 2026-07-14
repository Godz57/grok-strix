# Install Grok Strix wrapper into ~/.grok or ./.grok
param(
    [switch]$Project,
    [string]$KitRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = "Stop"

if ($Project) {
    $base = Join-Path (Get-Location) ".grok"
    Write-Host "Install mode: PROJECT -> $base"
} else {
    $base = Join-Path $env:USERPROFILE ".grok"
    Write-Host "Install mode: GLOBAL -> $base"
}

$skills = Join-Path $base "skills"
$commands = Join-Path $base "commands"
$dst = Join-Path $skills "strix"

New-Item -ItemType Directory -Force -Path $skills, $commands, $dst | Out-Null
Copy-Item -Recurse -Force (Join-Path $KitRoot "skills\strix\*") $dst
Write-Host "  skill: strix"

Get-ChildItem (Join-Path $KitRoot "commands") -Filter "*.md" | ForEach-Object {
    Copy-Item -Force $_.FullName (Join-Path $commands $_.Name)
    Write-Host "  command: $($_.Name)"
}

Write-Host ""
Write-Host "Wrapper installed. Strix CLI is separate:"
Write-Host "  1) Docker running"
Write-Host "  2) curl -sSL https://strix.ai/install | bash   (or see https://docs.strix.ai)"
Write-Host "  3) export STRIX_LLM=... and LLM_API_KEY=..."
Write-Host ""
Write-Host "Try: /strix-status  |  /strix-scan ."
