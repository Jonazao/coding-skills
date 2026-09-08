---
name: assessment_implementation_planning
description: Triggers when the user inputs 'assessment-plan' to create or update surgical plans for a specific task under the multi-task framework.
---
# Technical Assessment: Implementation Planning (Multi-Task)

You are running under the **Technical Assessment Orchestrator** framework. The goal of this phase is to create or update a step-by-step implementation plan for the active task.

## Instructions

1. **Resolve Active Task**:
   - Parse the prompt to check if a specific Task ID (e.g., `task-1`) is provided.
   - Read `.assessment/tasks.json` in the current workspace.
   - **Case A: Task ID specified**: Select that task.
   - **Case B: No Task ID specified**:
     - Filter tasks in `tasks.json` that have status `Open` or `In Progress`.
     - If there are multiple active tasks, print a clean markdown table of those tasks (showing ID, Name, Full Title, and Status) and ask the user to clarify (e.g. "Please run `assessment-plan <task_id>`"). Stop execution.
     - If there is exactly one active task, select it.
     - If there are no active tasks, instruct the user to run `assessment-interpret` first. Stop execution.

2. **Conduct Planning**:
   - Read `.assessment/tasks/[task_id]/task_understanding.md` and `.assessment/architecture_summary.md`.
   - Formulate a plan mapping target files to modify, complexity, dependency-ordered tasks, and test commands.
   - If the user runs `assessment-plan [task_id] update: [details]`, read the existing `implementation_plan.md` first and merge adjustments.

3. **Generate/Update Plan File**:
   - Write or overwrite `.assessment/tasks/[task_id]/implementation_plan.md`.
   - Update the task's status to `In Progress` and set `updated_at` in `.assessment/tasks.json`.

4. **Template for `implementation_plan.md`**:
   ```markdown
   # Implementation Plan: [Short Name] ([Task ID])

   ## Proposed File Changes
   - **File**: `[file path]`
     - **Complexity**: [Low/Medium/High]
     - **Action**: [Surgical modification summary]

   ## Execution Sequence
   1. **Step 1: [Short Action]**
      - Target: `[file path]`
      - Verification: [Test command]
   ```

5. **Verify & Respond**:
   - Output the finalized plan summary, highlighting the target files and validation scripts. Instruct the user to execute the plan by running their code prompts prefixed with `Assessment:` (e.g. `Assessment: implement Step 1`).
