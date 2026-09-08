#!/usr/bin/env bash
# Technical Assessment Orchestrator - Installer for macOS / Linux
set -e

TARGET_DIR="${TARGET_DIR:-${HOME}/.gemini/config/skills}"
PLUGINS_DIR="${PLUGINS_DIR:-${HOME}/.gemini/config/plugins}"
REPO_URL="${REPO_URL:-https://github.com/Jonazao/coding-skills/archive/refs/heads/master.tar.gz}"

echo -e "\033[36m==========================================================\033[0m"
echo -e "\033[36m  Technical Assessment Orchestrator - Installer (macOS/Linux) \033[0m"
echo -e "\033[36m==========================================================\033[0m"

TEMP_DIR=""
cleanup() {
    if [ -n "${TEMP_DIR}" ] && [ -d "${TEMP_DIR}" ]; then
        rm -rf "${TEMP_DIR}"
    fi
}
trap cleanup EXIT

# 1. Determine Source Directory
SCRIPT_DIR=""
if [ -n "${BASH_SOURCE[0]}" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"
fi

LOCAL_PACKAGE_DIR=""
if [ -n "${SCRIPT_DIR}" ] && [ -d "${SCRIPT_DIR}/package/skills" ]; then
    LOCAL_PACKAGE_DIR="${SCRIPT_DIR}/package/skills"
fi

if [ -n "${LOCAL_PACKAGE_DIR}" ] && [ -d "${LOCAL_PACKAGE_DIR}" ]; then
    SOURCE_DIR="${LOCAL_PACKAGE_DIR}"
    LOCAL_PLUGIN_DIR="${SCRIPT_DIR}/package/plugins/assessment-orchestrator"
    echo -e "\033[32m[✓] Found local package skills in: ${SOURCE_DIR}\033[0m"
else
    echo -e "\033[33m[*] Local package not detected. Fetching latest release from GitHub...\033[0m"
    echo -e "\033[90m[*] Target URL: ${REPO_URL}\033[0m"
    TEMP_DIR=$(mktemp -d)
    
    if ! curl -fsSL "${REPO_URL}" | tar -xz -C "${TEMP_DIR}" 2>/dev/null; then
        echo -e "\033[31m[!] Failed to download or unpack release archive from: ${REPO_URL}\033[0m"
        echo -e "\033[33m    Tip: If using a custom repository, run:\033[0m"
        echo -e "\033[33m    REPO_URL=\"https://github.com/<your-username>/.../archive/refs/heads/main.tar.gz\" ./install.sh\033[0m"
        exit 1
    fi

    SOURCE_DIR=$(find "${TEMP_DIR}" -type d -name "skills" | head -n 1)
    if [ -z "${SOURCE_DIR}" ] || [ ! -d "${SOURCE_DIR}" ]; then
        echo -e "\033[31m[!] Error: Could not locate skills directory inside downloaded package.\033[0m"
        exit 1
    fi
    LOCAL_PLUGIN_DIR=$(find "${TEMP_DIR}" -type d -name "assessment-orchestrator" | head -n 1)
fi

# 2. Create Target Directory
mkdir -p "${TARGET_DIR}"

# 3. Copy Skills
SKILLS=(
    "assessment_repo_analysis"
    "assessment_task_understanding"
    "assessment_implementation_planning"
    "assessment_execution_rules"
    "assessment_validation"
    "assessment_change_review"
    "assessment_justify"
)

echo -e "\033[33m[*] Installing skills to: ${TARGET_DIR}\033[0m"

for skill in "${SKILLS[@]}"; do
    SRC_SKILL="${SOURCE_DIR}/${skill}"
    DST_SKILL="${TARGET_DIR}/${skill}"
    
    if [ -d "${SRC_SKILL}" ]; then
        mkdir -p "${DST_SKILL}"
        cp -R "${SRC_SKILL}/"* "${DST_SKILL}/"
        echo -e "  \033[32m[+] Installed skill: ${skill}\033[0m"
    else
        echo -e "  \033[31m[!] Warning: Skill not found in source: ${skill}\033[0m"
    fi
done

# Ensure python helper scripts are executable
if [ -f "${TARGET_DIR}/assessment_change_review/scripts/diff_reviewer.py" ]; then
    chmod +x "${TARGET_DIR}/assessment_change_review/scripts/diff_reviewer.py"
fi

# 4. Install Plugin Manifest if available
if [ -n "${LOCAL_PLUGIN_DIR}" ] && [ -d "${LOCAL_PLUGIN_DIR}" ]; then
    DST_PLUGIN="${PLUGINS_DIR}/assessment-orchestrator"
    mkdir -p "${DST_PLUGIN}"
    cp -R "${LOCAL_PLUGIN_DIR}/"* "${DST_PLUGIN}/"
    echo -e "  \033[32m[+] Installed plugin manifest: assessment-orchestrator\033[0m"
fi

echo ""
echo -e "\033[36m==========================================================\033[0m"
echo -e "\033[32m  Installation Successful!\033[0m"
echo -e "\033[36m==========================================================\033[0m"
echo "You can now use the assessment orchestrator in any workspace!"
echo ""
echo "Quick-Start Workflow Commands:"
echo "  1. assessment-analyze"
echo "  2. assessment-interpret task-1 (My Task): <details>"
echo "  3. assessment-plan task-1"
echo "  4. Assessment: <implementation task>"
echo "  5. assessment-validate"
echo "  6. assessment-review"
echo "  7. assessment-justify"
echo ""
