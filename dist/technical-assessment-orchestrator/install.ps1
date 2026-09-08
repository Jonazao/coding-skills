# Technical Assessment Orchestrator - Installer for Windows
param(
    [string]$TargetDir = "$HOME/.gemini/config/skills",
    [string]$PluginsDir = "$HOME/.gemini/config/plugins",
    [string]$RepoUrl = "https://github.com/alexcastromr/technical-assessment-orchestrator/archive/refs/heads/main.zip"
)

$ErrorActionPreference = 'Stop'

Write-Host '==========================================================' -ForegroundColor Cyan
Write-Host '  Technical Assessment Orchestrator - Installer (Windows)' -ForegroundColor Cyan
Write-Host '==========================================================' -ForegroundColor Cyan

# Check if running locally with an existing package directory
$LocalPackageDir = if ($PSScriptRoot) { Join-Path $PSScriptRoot 'package/skills' } else { $null }
$LocalPluginDir  = if ($PSScriptRoot) { Join-Path $PSScriptRoot 'package/plugins/assessment-orchestrator' } else { $null }
$IsRemoteDownload = $false
$TempZip = $null
$TempExtract = $null

if ($LocalPackageDir -and (Test-Path $LocalPackageDir)) {
    $SourceDir = $LocalPackageDir
    Write-Host ('[+] Found local package skills in: ' + $SourceDir) -ForegroundColor Green
} else {
    Write-Host '[*] Local package not detected. Fetching latest release from GitHub...' -ForegroundColor Yellow
    Write-Host ('[*] Target URL: ' + $RepoUrl) -ForegroundColor Gray
    $IsRemoteDownload = $true
    $TempZip = Join-Path ([System.IO.Path]::GetTempPath()) 'assessment-orchestrator.zip'
    $TempExtract = Join-Path ([System.IO.Path]::GetTempPath()) 'assessment-orchestrator-extracted'
    
    if (Test-Path $TempExtract) {
        Remove-Item -Path $TempExtract -Recurse -Force -ErrorAction SilentlyContinue
    }
    
    try {
        Invoke-WebRequest -Uri $RepoUrl -OutFile $TempZip -UseBasicParsing
    } catch {
        Write-Host ('[!] Failed to download release archive from: ' + $RepoUrl) -ForegroundColor Red
        Write-Host ('[!] Error details: ' + $_.Exception.Message) -ForegroundColor Red
        Write-Host '    Tip: If you haven''t pushed to GitHub yet or are using a different repo,' -ForegroundColor Yellow
        Write-Host '    pass: .\install.ps1 -RepoUrl "https://github.com/<your-username>/.../archive/refs/heads/main.zip"' -ForegroundColor Yellow
        exit 1
    }

    Expand-Archive -Path $TempZip -DestinationPath $TempExtract -Force
    $SkillsDirMatch = Get-ChildItem -Path $TempExtract -Recurse -Directory -Filter 'skills' | Select-Object -First 1
    if (-not $SkillsDirMatch) {
        Write-Host '[!] Error: Could not locate skills directory inside downloaded package.' -ForegroundColor Red
        exit 1
    }
    $SourceDir = $SkillsDirMatch.FullName
    $PluginDirMatch = Get-ChildItem -Path $TempExtract -Recurse -Directory -Filter 'assessment-orchestrator' | Select-Object -First 1
    if ($PluginDirMatch) {
        $LocalPluginDir = $PluginDirMatch.FullName
    }
}

if (-not (Test-Path $TargetDir)) {
    Write-Host ('[*] Creating target directory: ' + $TargetDir) -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
}

$Skills = @(
    'assessment_repo_analysis',
    'assessment_task_understanding',
    'assessment_implementation_planning',
    'assessment_execution_rules',
    'assessment_validation',
    'assessment_change_review',
    'assessment_justify'
)

Write-Host ('[*] Installing skills to: ' + $TargetDir) -ForegroundColor Yellow

foreach ($Skill in $Skills) {
    $SrcSkillPath = Join-Path $SourceDir $Skill
    $DstSkillPath = Join-Path $TargetDir $Skill

    if (Test-Path $SrcSkillPath) {
        if (-not (Test-Path $DstSkillPath)) {
            New-Item -ItemType Directory -Path $DstSkillPath -Force | Out-Null
        }
        Copy-Item -Path ($SrcSkillPath + '/*') -Destination $DstSkillPath -Recurse -Force
        Write-Host ('  [+] Installed skill: ' + $Skill) -ForegroundColor Green
    } else {
        Write-Host ('  [!] Warning: Skill not found in source: ' + $Skill) -ForegroundColor Red
    }
}

# Install plugin manifest if available
if ($LocalPluginDir -and (Test-Path $LocalPluginDir)) {
    $DstPluginPath = Join-Path $PluginsDir 'assessment-orchestrator'
    if (-not (Test-Path $DstPluginPath)) {
        New-Item -ItemType Directory -Path $DstPluginPath -Force | Out-Null
    }
    Copy-Item -Path ($LocalPluginDir + '/*') -Destination $DstPluginPath -Recurse -Force
    Write-Host '  [+] Installed plugin manifest: assessment-orchestrator' -ForegroundColor Green
}

# Clean up temp artifacts if downloaded
if ($IsRemoteDownload) {
    if ($TempZip -and (Test-Path $TempZip)) {
        Remove-Item -Path $TempZip -Force -ErrorAction SilentlyContinue
    }
    if ($TempExtract -and (Test-Path $TempExtract)) {
        Remove-Item -Path $TempExtract -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Write-Host ''
Write-Host '==========================================================' -ForegroundColor Cyan
Write-Host '  Installation Successful!' -ForegroundColor Green
Write-Host '==========================================================' -ForegroundColor Cyan
Write-Host 'You can now use the assessment orchestrator in any workspace!'
Write-Host ''
Write-Host 'Quick-Start Workflow Commands:' -ForegroundColor White
Write-Host '  1. assessment-analyze' -ForegroundColor Yellow
Write-Host '  2. assessment-interpret task-1 (My Task): [details]' -ForegroundColor Yellow
Write-Host '  3. assessment-plan task-1' -ForegroundColor Yellow
Write-Host '  4. Assessment: [implementation task]' -ForegroundColor Yellow
Write-Host '  5. assessment-validate' -ForegroundColor Yellow
Write-Host '  6. assessment-review' -ForegroundColor Yellow
Write-Host '  7. assessment-justify' -ForegroundColor Yellow
Write-Host ''
