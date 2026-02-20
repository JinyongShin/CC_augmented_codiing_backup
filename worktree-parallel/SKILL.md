---
name: worktree-parallel
description: |
  Parallel development workflow using git worktree. Use when the user wants to work on
  multiple independent tasks simultaneously. Triggers on phrases like "parallel tasks",
  "run in parallel", "worktree", "multiple features at once", or "parallel development".
argument-hint: "[task1] [task2] [task3] ..."
disable-model-invocation: false
user-invocable: true
allowed-tools: Bash, Read, Write, Glob, Grep, Task
---

# Worktree Parallel Workflow

Execute parallel development for: `$ARGUMENTS`

## Current Git State

Branch: !`git branch --show-current`

Uncommitted changes:
```
!`git status --short`
```

Existing worktrees:
```
!`git worktree list`
```

---

## Instructions

Follow Phases 1 → 2 → 3 → 4 in order. Phase 2 runs subagents in parallel automatically — the user does NOT need to open separate terminals.

---

## Phase 1: Create Worktrees

### 1-1. Check for uncommitted changes

If there are uncommitted changes, ask the user whether to stash or commit them before proceeding.

### 1-2. Create a worktree and branch per task

Parse `$ARGUMENTS` by whitespace to extract each task name. For each task, run:

```bash
PROJECT_NAME=$(basename $(pwd))
BASE_DIR=$(pwd)

git worktree add "../${PROJECT_NAME}_<task>" -b "worktree/<task>"
```

Also create environment symlinks if applicable:

```bash
# If tests/.test_env exists
ln -sf "${BASE_DIR}/tests/.test_env" "../${PROJECT_NAME}_<task>/tests/.test_env"

# If .env exists
ln -sf "${BASE_DIR}/.env" "../${PROJECT_NAME}_<task>/.env"
```

### 1-3. Write a TASK.md in each worktree

Create a `TASK.md` file in each worktree using this template:

```markdown
# Task: <task-name>

## Objective
<description derived from $ARGUMENTS or user-provided context>

## Branch Info
- Branch: `worktree/<task-name>`
- Worktree path: `../<PROJECT_NAME>_<task-name>`
- Base branch: `<current branch>`

## Definition of Done
- [ ] Implementation complete
- [ ] All tests pass
- [ ] Changes committed
```

---

## Phase 2: Parallel Execution via Subagents

**Do NOT ask the user to open terminals.**

You MUST call the Task tool N times **in a single response message** — once per task.
Calling them in the same response is what makes them run concurrently.
If you call them across separate responses, they run sequentially. That defeats the purpose.

```
CORRECT — one response, N Task tool calls fired at the same time:
┌─────────────────────────────────────────────────┐
│ response                                        │
│   Task("implement OAuth2 login",  path=.../auth)   │  ← fires simultaneously
│   Task("integrate Stripe API",    path=.../pay )   │  ← fires simultaneously
│   Task("add Redis caching",       path=.../cache)  │  ← fires simultaneously
└─────────────────────────────────────────────────┘

WRONG — separate responses, runs one after another:
  response 1: Task("implement OAuth2 login")   ← waits to finish
  response 2: Task("integrate Stripe API")     ← then this
  response 3: Task("add Redis caching")        ← then this
```

### Subagent prompt template

Use this prompt for each Task call (substitute actual values):

```
You are working in the git worktree located at: <ABSOLUTE_PATH_TO_WORKTREE>

Your assigned task: <task description>

Instructions:
1. All file reads, writes, and edits must use the worktree path above.
   Use absolute paths or cd into the directory first.
2. Implement the task. Follow TDD (Red → Green → Refactor) if tests are involved.
3. Run tests to verify correctness:
   - Python: uv run pytest -v -s
   - Node.js: npm test
   - Go: go test ./...
4. Commit all changes:
   git -C <ABSOLUTE_PATH_TO_WORKTREE> add -A
   git -C <ABSOLUTE_PATH_TO_WORKTREE> commit -m "feat: <task description>"
5. Return a summary: what you implemented, files changed, test results.

Do not modify any files outside the worktree path above.
```

Wait for **all** Task calls to return before proceeding to Phase 3.

---

## Phase 3: Sequential Integration

After all subagents report completion, integrate the branches one at a time.

### 3-1. Pre-merge check

```bash
git status
git worktree list
```

### 3-2. Merge branches one by one (⚠️ sequential, never all at once)

For each branch in order:

```bash
git merge worktree/<task> --no-edit
```

Then immediately run the full test suite. Fix any failures before moving to the next branch.

**Conflict resolution rules:**
- `plan.md` conflict → mark both sides as `[x]`
- Test file conflict → include both test functions
- Implementation conflict → combine both changes so both features coexist

**Never:**
- Abort a merge and manually copy files ❌
- Skip a conflict and continue to the next branch ❌

### 3-3. Full test suite after all merges

Run the complete test suite and confirm everything passes before cleanup.

---

## Phase 4: Cleanup

After all tests pass:

```bash
PROJECT_NAME=$(basename $(pwd))

# Remove worktrees
git worktree remove "../${PROJECT_NAME}_<task1>" --force
git worktree remove "../${PROJECT_NAME}_<task2>" --force
# ... repeat for each task

# Delete branches
git branch -d worktree/<task1> worktree/<task2> ...

# Verify
git worktree list
git branch
```

Finish with a summary report to the user:
- Tasks completed
- Commits created (with hashes)
- Test results
- Total time from Phase 1 to Phase 4

---

## Supporting files

- [reference.md](reference.md) — env file sharing, conflict patterns, troubleshooting, automation scripts
