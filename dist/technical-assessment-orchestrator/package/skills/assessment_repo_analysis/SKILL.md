---
name: assessment_repo_analysis
description: Triggers when the user inputs 'assessment-analyze' or explicitly requests repository architecture analysis.
---
# Technical Assessment: Repository Analysis

You are running under the **Technical Assessment Orchestrator** framework. The goal of this phase is to analyze the unfamiliar repository and summarize its architecture, making it globally reusable for all subsequent tasks.

## Instructions

1. **Verify & Initialize State Directories**:
   - Check if the `.assessment` directory exists. Create it if it does not.
   - Check if the `.assessment/tasks` directory exists. Create it if it does not.
   - Check if `.assessment/tasks.json` exists. If it does not exist, initialize it with a default empty task array:
     ```json
     {
       "tasks": []
     }
     ```

2. **Conduct Codebase Inspection**:
   - Do NOT run modifying commands. Use read-only tools (`list_dir`, `grep_search`, `view_file`) to discover project framework, package manager, build scripts, linter, testing framework, directory layout, and key libraries.

3. **Generate Architecture Summary**:
   - Create or overwrite `.assessment/architecture_summary.md`. Note: This file will not be deleted when new tasks are started, keeping it reusable.
   - Use the standard structure:
     ```markdown
     # Repository Architecture Summary

     ## Core Technologies
     - **Framework/Runtime**: [e.g. Next.js, React]
     - **Package Manager**: [e.g. npm]
     - **Build Commands**: [e.g. npm run build]

     ## Testing & Quality Control
     - **Linter**: [e.g. ESLint]
     - **Testing Framework**: [e.g. Jest]
     - **Test Commands**: [e.g. npm test]

     ## Project Layout & Conventions
     - **Key Entry Points**: [e.g. src/app/page.tsx]
     - **Logic & Components**: [e.g. src/components/]
     - **Styling Setup**: [e.g. Tailwind CSS]
     ```

4. **Verify & Respond**:
   - Output a response confirming directories are initialized and the architecture summary has been generated. Direct the user to register their first task using the `assessment-interpret` command.
