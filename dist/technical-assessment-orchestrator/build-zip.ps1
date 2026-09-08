# Technical Assessment Orchestrator - Distribution ZIP Builder
# Creates a clean .zip package ready to distribute to colleagues.

$ErrorActionPreference = 'Stop'
$ScriptDir = $PSScriptRoot
$ZipName = "technical-assessment-orchestrator.zip"
$OutputPath = Join-Path (Split-Path $ScriptDir -Parent) $ZipName

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Packaging Technical Assessment Orchestrator into ZIP    " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# Stage files into a clean temp folder
$TempStage = Join-Path ([System.IO.Path]::GetTempPath()) "ta-orchestrator-stage"
if (Test-Path $TempStage) {
    Remove-Item -Path $TempStage -Recurse -Force
}
New-Item -ItemType Directory -Path $TempStage -Force | Out-Null

$FilesToInclude = @(
    "README.md",
    "install.ps1",
    "install.sh",
    "uninstall.ps1",
    "uninstall.sh",
    ".gitignore",
    "package"
)

foreach ($Item in $FilesToInclude) {
    $Src = Join-Path $ScriptDir $Item
    if (Test-Path $Src) {
        Copy-Item -Path $Src -Destination $TempStage -Recurse -Force
        Write-Host "  [+] Included: $Item" -ForegroundColor Green
    } else {
        Write-Host "  [!] Warning: Item not found: $Item" -ForegroundColor Red
    }
}

if (Test-Path $OutputPath) {
    Remove-Item -Path $OutputPath -Force
}

Write-Host "`n[*] Compressing archive to: $OutputPath" -ForegroundColor Yellow
Compress-Archive -Path (Join-Path $TempStage "*") -DestinationPath $OutputPath -Force

# Clean up temporary staging
Remove-Item -Path $TempStage -Recurse -Force -ErrorAction SilentlyContinue

$ZipSizeKB = [math]::Round(((Get-Item $OutputPath).Length / 1KB), 2)
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  ZIP Package Created Successfully! ($ZipSizeKB KB)" -ForegroundColor Green
Write-Host "  Location: $OutputPath" -ForegroundColor White
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "`nYou can now email or send this file to your colleagues." -ForegroundColor White
