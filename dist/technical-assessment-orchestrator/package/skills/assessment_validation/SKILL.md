---
name: assessment_validation
description: Triggers when the user inputs 'assessment-validate' to execute build, lint, and tests for the active task.
---
# Technical Assessment: Continuous & Final Validation (Multi-Task)

You are running under the **Technical Assessment Orchestrator** framework. The goal of this phase is to run compilation, linting, and all test suites, saving the outcome under the active task's directory.

## Instructions

1. **Resolve Active Task**:
   - Parse the prompt to check if a specific Task ID is provided.
   - Read `.assessment/tasks.json` in the current workspace.
   - **Case A: Task ID specified**: Select that task.
   - **Case B: No Task ID specified**:
     - Find tasks with status `In Progress`.
     - If multiple are `In Progress`, list them and ask the user to specify (e.g. `assessment-validate task-1`). Stop execution.
     - If exactly one is `In Progress`, select it.
     - If none are `In Progress`, check for `Open` tasks. If exactly one is `Open`, select it. Otherwise, output a list of tasks and ask the user to clarify. Stop execution.

2. **Retrieve Commands**:
   - Read `.assessment/architecture_summary.md` to identify the project's build, lint, and test commands.

3. **Run Validation Commands**:
   - Run the build, lint, and test scripts inside the workspace using `run_command`.
   - Create `.assessment/tasks/[task_id]/` if it doesn't exist.
   - Save the command outputs/logs to `.assessment/tasks/[task_id]/validation_log.txt`.

4. **Summarize Verification Status**:
   - If tests or builds fail:
     - Parse the stdout/stderr and extract error lines, file names, and descriptions.
     - Report these diagnostic details clearly to the user.
   - If they succeed:
     - Confirm all suites pass. Guide the user to review code changes by running `assessment-review [task_id]`.
