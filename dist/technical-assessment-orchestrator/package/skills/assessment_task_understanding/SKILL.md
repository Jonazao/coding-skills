---
name: assessment_task_understanding
description: Triggers when the user inputs 'assessment-interpret' to register, analyze, or update task constraints and definitions of done under a specific task ID.
---
# Technical Assessment: Task Understanding (Multi-Task)

You are running under the **Technical Assessment Orchestrator** framework. The goal of this phase is to parse, register, and update task-specific requirements under a dedicated task directory.

## Instructions

1. **Parse the Command**:
   - Parse the prompt to identify:
     - **Task ID**: (e.g. `task-1`)
     - **Short Name (optional)**: Specified in parentheses (e.g. `(Filter Fix)`). If omitted, automatically generate a short, descriptive name (e.g. `Filter Page Update`, `Pagination Fix`, `Logout Fix`).
     - **Description/Details**: The task details or update content.
     - **Mode**: Check if the command contains `update: [details]`.

2. **Verify State Registry**:
   - Ensure `.assessment/tasks.json` and `.assessment/tasks/` exist.
   - Read `.assessment/tasks.json`.

3. **Handle Task Registration & Setup**:
   - **For a New Task Registration**:
     - Check if the Task ID already exists in `tasks.json`. If it does, instruct the user to use the `update` keyword or choose a unique ID.
     - Create a folder at `.assessment/tasks/[task_id]/` if it does not exist.
     - Formulate the task understanding based on the task description and write it to `.assessment/tasks/[task_id]/task_understanding.md`.
     - Append the new task to the `tasks` list in `tasks.json`:
       - `id`: `[task_id]`
       - `name`: `[short name]`
       - `title`: `[full task description]`
       - `status`: `Open`
       - `created_at`: Current ISO timestamp
       - `updated_at`: Current ISO timestamp
   - **For Task Updates (`assessment-interpret [task_id] update: [details]`)**:
     - Locate the task in `tasks.json` and `.assessment/tasks/[task_id]/task_understanding.md`. If not found, return an error.
     - Read the existing `task_understanding.md`, merge the clarifications or adjustments from the prompt, and overwrite it.
     - Update the task's `updated_at` timestamp in `tasks.json`.

4. **Template for `task_understanding.md`**:
   ```markdown
   # Task Understanding: [Short Name] ([Task ID])

   ## Problem Statement
   - [Full requirement text]

   ## DoD (Definition of Done)
   - [x] All existing build, lint, and test suites pass.
   - [x] Specific problem solved.
   - [ ] [DoD item 1]
   - [ ] [DoD item 2]

   ## Constraints & Boundaries
   - **Explicit Constraints**: [e.g. do not modify router APIs]
   - **Implicit Assumptions**: [e.g. user details are fetched on mount]
   ```

5. **Verify & Respond**:
   - Confirm registration/update of the task. Output the short name, full title, and status, then guide the user to run `assessment-plan [task_id]` next.
