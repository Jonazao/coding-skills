---
name: assessment_execution_rules
description: Triggers on coding tasks prefixed with 'Assessment:' or 'assessment mode:' to enforce the decision framework and scope protection based on the active task's plan.
---
# Technical Assessment: Execution & Scope Protection (Multi-Task)

You are executing an implementation step. You must adhere to the active task's plan and enforce scope protection rules.

## Instructions

1. **Resolve Active Task**:
   - Read `.assessment/tasks.json` in the current workspace.
   - Filter for tasks with status `In Progress`.
   - **Case A: Exactly one task is `In Progress`**: Select that task ID.
   - **Case B: Multiple tasks are `In Progress`**:
     - Check if the prompt starts with a task ID marker (e.g. `Assessment: [task-1] ...` or `Assessment: task-1 ...`). If so, select that task ID.
     - Otherwise, output a list of active tasks and ask the user to clarify which task this code change applies to. Stop execution.
   - **Case C: No tasks are `In Progress`**:
     - Check if there is exactly one `Open` task in `tasks.json`. If so, select it, set its status to `In Progress` in `tasks.json`, and continue.
     - Otherwise, warn the user to run `assessment-plan` first. Stop execution.

2. **Load Task context**:
   - Read `.assessment/tasks/[task_id]/task_understanding.md` and `.assessment/tasks/[task_id]/implementation_plan.md` to load the task scope, DoD, and proposed modifications.

3. **Enforce Decision Framework & Constraints**:
   - **Correctness & Passing Tests**: The fix must solve the issue and make tests pass.
   - **Surgical Changes**: Prefer the simplest edit. Do not refactor unrelated systems.
   - **Scope Check**: If the requested change goes outside the files listed in `implementation_plan.md`, introduces new packages, or performs speculative refactoring:
     - **Output a clear warning alert** explaining the risk and suggesting a surgical alternative (e.g., `> [!WARNING] Modifying file X exceeds the approved plan for [Task ID]...`).

4. **Implement & Guide**:
   - Perform the code change using `replace_file_content` or `multi_replace_file_content`.
   - **Update DoD Progress**: Immediately after making code changes, read the active task's `.assessment/tasks/[task_id]/task_understanding.md` file. Check off any Definition of Done (DoD) items you just implemented by changing their markdown checkboxes from `[ ]` to `[x]`, then write the updated content back to the file.
   - Remind the user to run `assessment-validate` once completed.
