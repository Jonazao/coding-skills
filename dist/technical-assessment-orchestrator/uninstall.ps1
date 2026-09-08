# Technical Assessment Orchestrator - Uninstaller for Windows
param(
    [string]$TargetDir = "$HOME/.gemini/config/skills",
    [string]$PluginsDir = "$HOME/.gemini/config/plugins"
)

$Skills = @(
    'assessment_repo_analysis',
    'assessment_task_understanding',
    'assessment_implementation_planning',
    'assessment_execution_rules',
    'assessment_validation',
    'assessment_change_review',
    'assessment_justify'
)

Write-Host '[*] Uninstalling Technical Assessment Orchestrator skills and plugins...' -ForegroundColor Yellow

foreach ($Skill in $Skills) {
    $SkillPath = Join-Path $TargetDir $Skill
    if (Test-Path $SkillPath) {
        Remove-Item -Path $SkillPath -Recurse -Force
        Write-Host ('  [-] Removed skill: ' + $Skill) -ForegroundColor Red
    }
}

$PluginPath = Join-Path $PluginsDir 'assessment-orchestrator'
if (Test-Path $PluginPath) {
    Remove-Item -Path $PluginPath -Recurse -Force
    Write-Host '  [-] Removed plugin manifest: assessment-orchestrator' -ForegroundColor Red
}

Write-Host '[+] Uninstallation complete.' -ForegroundColor Green
