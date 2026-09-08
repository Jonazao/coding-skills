---
name: assessment_change_review
description: Triggers when the user inputs 'assessment-review' to check active git changes for code hygiene under the multi-task framework.
---
# Technical Assessment: Submission Change Review (Multi-Task)

You are running under the **Technical Assessment Orchestrator** framework. The goal of this phase is to scan your modifications for the active task and check for debug statements, TODOs, or commented code.

## Instructions

1. **Resolve Active Task**:
   - Read `.assessment/tasks.json` in the current workspace.
   - If a task ID is specified in the prompt, select it.
   - If not, select the task with status `In Progress`. If multiple are `In Progress` or none, list the tasks and ask the user to clarify (e.g. `assessment-review task-1`). Stop execution.

2. **Run Code Hygiene Review**:
   - Locate the Python helper script `diff_reviewer.py`:
     - Check for the local workspace drop-in first: `.agents/skills/assessment_change_review/scripts/diff_reviewer.py`
     - If not found, use the global installation: `~/.gemini/config/skills/assessment_change_review/scripts/diff_reviewer.py` (or `$HOME/.gemini/config/skills/...`)
   - Execute the script using `run_command` with `python` (Windows) or `python3` (macOS/Linux):
     ```bash
     python "<path_to_diff_reviewer.py>"
     ```
   - Capture the output and exit code.

3. **Save and Summarize Review**:
   - Create or overwrite `.assessment/tasks/[task_id]/review_results.md`.
   - Write the outcome (clean vs issues found) to this file.
   - If clean:
     - Output the readiness checklist:
       - [x] Task requirements completed.
       - [x] Code hygiene check passed.
       - [x] Build and test suite passed.
       - [ ] Solution justification written.
     - Recommend running `assessment-justify [task_id]` next.
   - If issues found:
     - Present the list of files and lines containing debug logs, TODOs, or commented-out code, and guide the user on how to fix them before submitting.
