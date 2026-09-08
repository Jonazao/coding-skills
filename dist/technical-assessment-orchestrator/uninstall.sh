#!/usr/bin/env bash
# Technical Assessment Orchestrator - Uninstaller for macOS / Linux
set -e

TARGET_DIR="${TARGET_DIR:-${HOME}/.gemini/config/skills}"
PLUGINS_DIR="${PLUGINS_DIR:-${HOME}/.gemini/config/plugins}"

SKILLS=(
    "assessment_repo_analysis"
    "assessment_task_understanding"
    "assessment_implementation_planning"
    "assessment_execution_rules"
    "assessment_validation"
    "assessment_change_review"
    "assessment_justify"
)

echo -e "\033[33mUninstalling Technical Assessment Orchestrator skills and plugins...\033[0m"

for skill in "${SKILLS[@]}"; do
    SKILL_PATH="${TARGET_DIR}/${skill}"
    if [ -d "${SKILL_PATH}" ]; then
        rm -rf "${SKILL_PATH}"
        echo -e "  \033[31m[-] Removed skill: ${skill}\033[0m"
    fi
done

PLUGIN_PATH="${PLUGINS_DIR}/assessment-orchestrator"
if [ -d "${PLUGIN_PATH}" ]; then
    rm -rf "${PLUGIN_PATH}"
    echo -e "  \033[31m[-] Removed plugin manifest: assessment-orchestrator\033[0m"
fi

echo -e "\033[32m[✓] Uninstallation complete.\033[0m"
