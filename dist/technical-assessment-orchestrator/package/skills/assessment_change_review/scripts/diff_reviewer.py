import sys
import subprocess
import re
import os

# Define regex patterns for code hygiene issues in added lines
PATTERNS = {
    "debug_log": [
        (re.compile(r'\bconsole\.(log|dir|error|warn)\('), "JavaScript console log"),
        (re.compile(r'\bdebugger\b'), "JavaScript debugger statement"),
        (re.compile(r'\bprint\s*\('), "Python/Ruby print statement"),
        (re.compile(r'\bpdb\.set_trace\(\)'), "Python debugger set_trace"),
        (re.compile(r'\bbreakpoint\(\)'), "Python breakpoint"),
        (re.compile(r'\bSystem\.out\.print(ln)?\('), "Java print statement"),
        (re.compile(r'\bfmt\.Print(f|ln)?\('), "Go print statement"),
    ],
    "todo": [
        (re.compile(r'\b(TODO|FIXME|XXX)\b', re.IGNORECASE), "TODO/FIXME marker"),
    ],
    "commented_code": [
        # Match lines that look like commented out code, e.g. // const x = 5; or # x = y + 1;
        (re.compile(r'^\s*(//|#)\s*(if|for|while|const|let|var|function|def|import|return|class|public|private)\b'), "Commented-out code line"),
    ]
}

IGNORED_EXTENSIONS = (
    '.md', '.markdown', '.json', '.yml', '.yaml', '.txt',
    '.svg', '.csv', '.lock', '.gitignore'
)

def get_git_diff():
    try:
        # Check if repository has at least one commit (valid HEAD)
        has_head = subprocess.run(
            ["git", "rev-parse", "--verify", "HEAD"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL
        ).returncode == 0

        diff_cmd = ["git", "diff", "HEAD"] if has_head else ["git", "diff", "--staged"]
        
        result = subprocess.run(
            diff_cmd,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            encoding="utf-8",
            errors="replace",
            check=True
        )
        
        # If no staged changes and no HEAD, also check unstaged diff
        if not has_head and not result.stdout.strip():
            unstaged_result = subprocess.run(
                ["git", "diff"],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                encoding="utf-8",
                errors="replace",
                check=True
            )
            return unstaged_result.stdout

        return result.stdout
    except subprocess.CalledProcessError as e:
        print(f"Error running git diff: {e.stderr}")
        sys.exit(1)
    except FileNotFoundError:
        print("Git command not found. Ensure git is installed and in PATH.")
        sys.exit(1)

def analyze_diff(diff_content):
    issues = []
    current_file = None
    line_num_in_file = 0
    hunk_header_re = re.compile(r'^@@ -\d+(?:,\d+)? \+(\d+)(?:,\d+)? @@')

    for line in diff_content.splitlines():
        if line.startswith('+++ b/'):
            current_file = line[6:]
            line_num_in_file = 0
            continue
        elif line.startswith('@@'):
            match = hunk_header_re.match(line)
            if match:
                line_num_in_file = int(match.group(1)) - 1
            continue

        if current_file:
            if line.startswith('+') and not line.startswith('+++'):
                line_num_in_file += 1
                
                # Skip files inside .assessment, the script itself, or non-code documentation/data files
                if (
                    ".assessment/" in current_file
                    or "diff_reviewer.py" in current_file
                    or current_file.lower().endswith(IGNORED_EXTENSIONS)
                ):
                    continue

                actual_content = line[1:]
                # Check for debug logs
                for pattern, desc in PATTERNS["debug_log"]:
                    if pattern.search(actual_content):
                        issues.append((current_file, line_num_in_file, desc, actual_content.strip()))

                # Check for TODOs
                for pattern, desc in PATTERNS["todo"]:
                    if pattern.search(actual_content):
                        issues.append((current_file, line_num_in_file, desc, actual_content.strip()))

                # Check for Commented out code
                for pattern, desc in PATTERNS["commented_code"]:
                    if pattern.search(actual_content):
                        issues.append((current_file, line_num_in_file, desc, actual_content.strip()))
            elif not line.startswith('-'):
                # Line context count
                line_num_in_file += 1

    return issues

def main():
    diff_content = get_git_diff()
    if not diff_content.strip():
        print("No local modifications detected in git. All clean!")
        sys.exit(0)

    issues = analyze_diff(diff_content)

    if issues:
        print("--- Code Hygiene Review: Issues Found ---")
        for filename, line, issue_type, content in issues:
            print(f"[{issue_type}] in {filename}:{line}")
            print(f"  >  {content}\n")
        print(f"Total issues found: {len(issues)}")
        sys.exit(1)
    else:
        print("Code hygiene review passed. No debug statements, TODOs, or commented-out code found!")
        sys.exit(0)

if __name__ == "__main__":
    main()
