# Worktree Parallel Workflow — Reference

## How it works

Git worktree checks out the **same repository** in multiple directories simultaneously.

```
Repository (shared)
├── .git/                  ← shared history, remotes, objects
├── project/               ← main working directory (current branch)
├── ../project_task1/      ← worktree 1 (branch: worktree/task1)
└── ../project_task2/      ← worktree 2 (branch: worktree/task2)
```

Each worktree has:
- Its own independent filesystem state
- Its own unique git branch
- Shared git history, objects, and remotes

---

## Subagent Parallelization

Phase 2 uses Claude's Task tool to launch multiple subagents concurrently.
Each subagent operates exclusively within its assigned worktree directory.

```
Main agent (orchestrator)
├── Subagent 1 → worktree/task1 → implements → commits
├── Subagent 2 → worktree/task2 → implements → commits
└── Subagent 3 → worktree/task3 → implements → commits
         ↓ (all complete)
Main agent merges sequentially
```

**Key constraint:** Subagents must use absolute paths or `git -C <path>` to ensure all
operations stay within their assigned worktree.

---

## Environment File Sharing

### Option 1: tests/.test_env symlink (recommended)

```bash
BASE_DIR=$(pwd)
PROJECT_NAME=$(basename $(pwd))

ln -sf "${BASE_DIR}/tests/.test_env" "../${PROJECT_NAME}_task1/tests/.test_env"
ln -sf "${BASE_DIR}/tests/.test_env" "../${PROJECT_NAME}_task2/tests/.test_env"
```

### Option 2: .env symlink

```bash
BASE_DIR=$(pwd)
PROJECT_NAME=$(basename $(pwd))

ln -sf "${BASE_DIR}/.env" "../${PROJECT_NAME}_task1/.env"
ln -sf "${BASE_DIR}/.env" "../${PROJECT_NAME}_task2/.env"
```

### Option 3: Export environment variables (temporary)

```bash
export $(cat .env | xargs)
```

---

## Conflict Resolution Patterns

### plan.md conflict

```
<<<<<<< HEAD
- [x] Test: Feature A
- [ ] Test: Feature B
=======
- [ ] Test: Feature A
- [x] Test: Feature B
>>>>>>> worktree/task2
```

**Resolution:** Mark both as complete

```markdown
- [x] Test: Feature A
- [x] Test: Feature B
```

### Test file conflict

```python
<<<<<<< HEAD
def test_feature_a():
    assert feature_a() == True
=======
def test_feature_b():
    assert feature_b() == True
>>>>>>> worktree/task2
```

**Resolution:** Include both functions

```python
def test_feature_a():
    assert feature_a() == True


def test_feature_b():
    assert feature_b() == True
```

### Implementation file conflict

```python
<<<<<<< HEAD
    if condition_a:
        return result_a
=======
    if condition_b:
        return result_b
>>>>>>> worktree/task2
```

**Resolution:** Combine both so both features coexist

```python
    if condition_a:
        return result_a
    if condition_b:
        return result_b
```

---

## Automation Scripts

### setup.sh — Create all worktrees at once

```bash
bash .claude/skills/worktree-parallel/scripts/setup.sh task1 task2 task3
```

### merge.sh — Sequential merge

```bash
bash .claude/skills/worktree-parallel/scripts/merge.sh task1 task2 task3
```

### cleanup.sh — Remove worktrees and branches

```bash
bash .claude/skills/worktree-parallel/scripts/cleanup.sh task1 task2 task3
```

---

## Time Efficiency

| Approach       | 4 tasks estimate |
|----------------|-----------------|
| Sequential     | ~28 min (7 min × 4) |
| Parallel       | ~10 min (setup 2 + execution 7 + integration 1) |
| **Savings**    | **~64%** |

---

## Troubleshooting

### Branch already exists

```bash
git worktree list
git worktree remove ../project_task1 --force
git branch -D worktree/task1
git worktree add ../project_task1 -b worktree/task1
```

### Worktree removal fails (uncommitted changes)

```bash
git worktree remove ../project_task1 --force
```

### Tests fail after merge

```bash
# Identify failing tests
pytest -v -s --tb=short    # Python
npm test -- --verbose      # Node.js

# Check which merge introduced the failure
git log --oneline --graph -10
git diff HEAD~1..HEAD
```

### Too many conflicts to proceed

```bash
# List conflicted files
git status

# Compare both versions
git show HEAD:path/to/file               # current version
git show worktree/task2:path/to/file     # incoming version

# Use merge tool
git mergetool
```

---

## Core Rules

1. **No bulk integration** — merge branches one at a time, sequentially
2. **No manual copy after abort** — always resolve conflicts through git
3. **Test after each merge** — catch issues early
4. **Always clean up** — remove worktrees after work is done
