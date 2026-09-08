# Technical Assessment Orchestrator for Antigravity

An expert technical lead persona and orchestration skill set for Google Antigravity designed for timed programming assessments and live coding evaluations.

It maximizes **correctness**, **passing tests**, **minimal code modifications (surgical changes)**, and **existing project conventions**, while preventing speculative refactoring and out-of-scope modifications.

---

## 🚀 Quick Install (For Colleagues)

### Option 1: One-Line Remote Install (Fastest)

> [!NOTE]
> Replace `<your-username>` with your GitHub username or organization where this repository is published.

*   **Windows (PowerShell)**:
    ```powershell
    irm https://raw.githubusercontent.com/<your-username>/technical-assessment-orchestrator/main/install.ps1 | iex
    ```

*   **macOS / Linux (Bash/Zsh)**:
    ```bash
    curl -fsSL https://raw.githubusercontent.com/<your-username>/technical-assessment-orchestrator/main/install.sh | bash
    ```

---

### Option 2: Local Install (Git Clone or ZIP Archive)

**From Git Clone:**
1. Clone this repository:
   ```bash
   git clone https://github.com/<your-username>/technical-assessment-orchestrator.git
   cd technical-assessment-orchestrator
   ```
2. Run the installer:
   * **Windows**: `.\install.ps1`
   * **macOS / Linux**: `./install.sh`

**From Shared ZIP Archive:**
1. Unzip `technical-assessment-orchestrator.zip` on your machine.
2. Open terminal in the unzipped directory and run:
   * **Windows**: `.\install.ps1`
   * **macOS / Linux**: `./install.sh`

---

### Option 3: Shared Project Drop-In (VCS Version Controlled)

To provide this skill set to anyone who clones your project repository without requiring global installation:
1. Copy the `package/skills/` directory into your project's `.agents/skills/` folder:
   ```text
   <your-project-root>/
   └── .agents/
       └── skills/
           ├── assessment_repo_analysis/
           ├── assessment_task_understanding/
           ├── assessment_implementation_planning/
           ├── assessment_execution_rules/
           ├── assessment_validation/
           ├── assessment_change_review/
           └── assessment_justify/
   ```
2. Commit `.agents/` to git. Any team member opening the project in Antigravity will have the orchestrator active automatically.

---

## 🎯 Command Reference & Workflow

When starting a timed assessment on an unfamiliar repository, run these commands directly in your Antigravity chat:

| Step | Command | Description |
| :--- | :--- | :--- |
| **1. Analysis** | `assessment-analyze` | Inspects codebase architecture, package manager, and test suites. Writes reusable `.assessment/architecture_summary.md`. |
| **2. Interpret** | `assessment-interpret [task_id] ([Name]): [details]` | Registers a task, extracts DoD checklist and constraints. Writes `.assessment/tasks/[task_id]/task_understanding.md`. |
| **3. Plan** | `assessment-plan [task_id]` *(or `assessment-plan`)* | Formulates a surgical step-by-step modification plan. Writes `.assessment/tasks/[task_id]/implementation_plan.md`. |
| **4. Execute** | `Assessment: [task prompt]` | Implements changes under strict Decision Framework guardrails and automatically checks off completed DoD items. |
| **5. Validate** | `assessment-validate [task_id]` | Automatically runs compilation, linter, and unit/E2E test suites, returning exact failure diagnostics. |
| **6. Clean Diff** | `assessment-review [task_id]` | Scans active git changes using `diff_reviewer.py` to flag leftover `console.log`, `print`, `TODO` markers, and commented code. |
| **7. Justify** | `assessment-justify [task_id]` | Generates `.assessment/tasks/[task_id]/justification_summary.md` and marks the task as `Completed` in `tasks.json`. |

---

## 📂 Multi-Task State Machine Structure

During an assessment, all artifacts are organized cleanly under the `.assessment/` directory in your workspace:

```text
.assessment/
├── architecture_summary.md       # Project-wide analysis (reusable across all tasks)
├── tasks.json                    # Central index tracking Task IDs, short names, and status
└── tasks/
    ├── task-1/                   # Task-specific subfolders
    │   ├── task_understanding.md # Problem scope & Definition of Done checklist
    │   ├── implementation_plan.md# Surgical plan & targeted files
    │   ├── validation_log.txt    # Build & test execution logs
    │   └── justification_summary.md # Final submission documentation
    └── task-2/
        └── ...
```

### Central Tasks Index (`.assessment/tasks.json`)
```json
{
  "tasks": [
    {
      "id": "task-1",
      "name": "Filter Fix",
      "title": "selecting filters wont update the page",
      "status": "Completed",
      "created_at": "2026-08-26T16:00:00Z",
      "updated_at": "2026-08-26T16:15:00Z"
    },
    {
      "id": "task-2",
      "name": "Datatable Pagination",
      "title": "datatable is loading all data instead of paginated data",
      "status": "In Progress",
      "created_at": "2026-08-26T16:00:00Z",
      "updated_at": "2026-08-26T16:00:00Z"
    }
  ]
}
```

---

## 🧠 Decision Framework

When evaluating multiple implementation strategies, the orchestrator enforces priorities in this exact order:
1. **Correctness**
2. **Passing tests**
3. **Minimal implementation (Surgical changes)**
4. **Existing project conventions**
5. **Readability & Maintainability**
6. **Performance & Architecture**

---

## 🗑️ Uninstallation

*   **Windows**: `.\uninstall.ps1`
*   **macOS / Linux**: `./uninstall.sh`
