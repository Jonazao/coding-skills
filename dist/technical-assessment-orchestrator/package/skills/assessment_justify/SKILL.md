---
name: assessment_justify
description: Triggers when the user inputs 'assessment-justify' to write the final submission justification for the active task.
---
# Technical Assessment: Solution Justification (Multi-Task)

You are running under the **Technical Assessment Orchestrator** framework. The goal of this phase is to produce a clean, concise technical explanation of your changes for the active task and mark it as completed.

## Instructions

1. **Resolve Active Task**:
   - Read `.assessment/tasks.json` in the current workspace.
   - If a task ID is specified in the prompt, select it.
   - If not, select the task with status `In Progress`. If multiple are `In Progress` or none, list the tasks and ask the user to clarify (e.g. `assessment-justify task-1`). Stop execution.

2. **Synthesize Justification Report**:
   - Read the task-specific files: `.assessment/tasks/[task_id]/task_understanding.md` and `.assessment/tasks/[task_id]/implementation_plan.md`.
   - **Final DoD Checklist Sync**: Verify that all Definition of Done (DoD) items in `task_understanding.md` that have been implemented are checked off (`[x]`). If any completed items are still unchecked, update them to `[x]` and overwrite `task_understanding.md`.
   - Inspect local changes and checkout files if needed to summarize modifications.
   - Read `.assessment/tasks/[task_id]/validation_log.txt` (or run a quick check) to confirm test status.

3. **Generate Justification file**:
   - Write or overwrite `.assessment/tasks/[task_id]/justification_summary.md`.
   - Use the following Markdown template:
     ```markdown
     # Solution Justification: [Short Name] ([Task ID])

     ## Objective
     - [Concise description of the problem solved]

     ## Surgical Approach
     - [Summary of changes made; explicitly list files modified]
     - [Justification for why this approach was chosen and how it minimizes changes]

     ## Architectural & Design Tradeoffs
     - [Design tradeoffs, e.g. simplicity over library imports]

     ## Verification & Quality Results
     - **Build Status**: [e.g. Successful]
     - **Test Outcome**: [e.g. All tests passing]
     ```

4. **Update Task Status**:
   - In `.assessment/tasks.json`, find the task with the selected Task ID.
   - Set `status` to `Completed`.
   - Update `updated_at` with the current ISO timestamp.

5. **Verify & Respond**:
   - Output a confirmation detailing the saved justification, list the completed tasks from `tasks.json`, and prompt the user to start their next task (if any) using `assessment-interpret`.
