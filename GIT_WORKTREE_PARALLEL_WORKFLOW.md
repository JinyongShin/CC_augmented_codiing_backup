# Git Worktree Parallel Workflow

A comprehensive guide for Claude Code to execute parallel development tasks using git worktree.

## Overview

### When to Use This Workflow

Use git worktree parallel workflow when:
- You have **multiple independent tasks** that can be worked on simultaneously
- Tasks don't depend on each other's implementation
- You want to **reduce development time** through parallelization
- Each task requires its own **isolated development environment**

### Benefits

- **Time Efficiency**: N tasks complete in ~max(task_time) instead of sum(task_times)
- **Clean History**: Each task gets its own branch with focused commits
- **Isolation**: No interference between parallel tasks
- **Flexibility**: Easy to abandon or restart individual tasks

### Time Comparison Example

**Sequential Development:**
- Task 1: 7 minutes
- Task 2: 7 minutes
- Task 3: 7 minutes
- Task 4: 7 minutes
- **Total: 28 minutes**

**Parallel Development:**
- All 4 tasks: 7 minutes (simultaneous)
- Integration: 2 minutes
- **Total: 9 minutes** (3x faster!)

---

## Quick Reference Checklist

```
□ Phase 0: Environment Setup
  □ Verify tests/.test_env exists
  □ Commit current changes

□ Phase 1: Worktree Setup (Claude Code)
  □ Create N worktrees
  □ Create branches for each worktree
  □ Generate TASK.md for each worktree
  □ Setup environment symlinks

□ Phase 2: Parallel Execution (User + Claude Code)
  □ Open N terminal sessions
  □ Start Claude Code in each worktree
  □ Execute assigned task in each session
  □ Commit changes in each branch

□ Phase 3: Integration (Claude Code)
  □ Merge branches sequentially
  □ Resolve conflicts
  □ Run full test suite
  □ Verify all tests pass

□ Phase 4: Cleanup (Claude Code)
  □ Remove worktrees
  □ Delete merged branches
  □ Push to remote
```

---

## Role Distribution

### Claude Code Responsibilities

**Phase 1 - Setup:**
- Create worktrees and branches
- Generate TASK.md files with clear instructions
- Setup environment file symlinks
- Verify worktree structure

**Phase 3 - Integration:**
- Merge branches in sequence
- Resolve merge conflicts
- Run comprehensive test suite
- Validate integration success

**Phase 4 - Cleanup:**
- Remove worktrees
- Delete merged branches
- Push changes to remote

### User Responsibilities

**Phase 2 - Parallel Execution:**
- Open N terminal windows/tabs
- Navigate to each worktree directory
- Start Claude Code session in each
- Provide task instructions to each Claude Code session
- Monitor progress across sessions

---

## Phase 0: Environment Setup

### Problem: Environment Files in Worktrees

Worktrees are separate working directories that don't automatically share configuration files like `.env`. This causes test failures when tests depend on environment variables.

### Solution: Symbolic Links

Create symbolic links to share environment configuration across worktrees.

#### Option 1: Main .env File (Simple)

```bash
# Link main .env to each worktree
ln -s $(pwd)/.env ../project_name_test1/.env
ln -s $(pwd)/.env ../project_name_test2/.env
ln -s $(pwd)/.env ../project_name_test3/.env
ln -s $(pwd)/.env ../project_name_test4/.env
```

**Pros:** Simple, single source of truth
**Cons:** Shares production/development config with tests

#### Option 2: tests/.test_env File (Recommended)

```bash
# Link test-specific env file
ln -s $(pwd)/tests/.test_env ../project_name_test1/tests/.test_env
ln -s $(pwd)/tests/.test_env ../project_name_test2/tests/.test_env
ln -s $(pwd)/tests/.test_env ../project_name_test3/tests/.test_env
ln -s $(pwd)/tests/.test_env ../project_name_test4/tests/.test_env
```

**Pros:** Test isolation, separate from main .env
**Cons:** Need to maintain tests/.test_env file

#### Option 3: Export Environment Variables (Temporary)

```bash
# For quick tests without file setup
export $(cat .env | xargs)
cd ../project_name_test1
# Environment variables now available
```

**Pros:** No file management
**Cons:** Variables not persisted, must export in each terminal

### Recommendation

**Use Option 2** (tests/.test_env with symlinks) for the following reasons:
- Maintains test isolation
- Shares configuration across worktrees
- Follows testing best practices
- Easy to automate in setup scripts

---

## Phase 1: Worktree Setup

### Manual Process

```bash
# 1. Verify current state
git status
git log --oneline -5

# 2. Create worktrees
git worktree add ../project_name_test1 -b test/feature-1
git worktree add ../project_name_test2 -b test/feature-2
git worktree add ../project_name_test3 -b test/feature-3
git worktree add ../project_name_test4 -b test/feature-4

# 3. Create TASK.md in each worktree
# (See TASK.md Template section below)

# 4. Setup environment symlinks
ln -s $(pwd)/tests/.test_env ../project_name_test1/tests/.test_env
ln -s $(pwd)/tests/.test_env ../project_name_test2/tests/.test_env
ln -s $(pwd)/tests/.test_env ../project_name_test3/tests/.test_env
ln -s $(pwd)/tests/.test_env ../project_name_test4/tests/.test_env

# 5. Verify setup
git worktree list
```

### Automated Setup Script

```bash
#!/bin/bash
# setup_worktrees.sh - Automate worktree creation with environment setup

set -e  # Exit on error

# Configuration
BASE_DIR=$(pwd)
PROJECT_NAME="${PWD##*/}"
WORKTREE_BASE="../${PROJECT_NAME}"
NUM_WORKTREES=4
FEATURE_NAMES=("feature-1" "feature-2" "feature-3" "feature-4")

echo "Setting up ${NUM_WORKTREES} worktrees for ${PROJECT_NAME}..."

# Verify we're in a git repository
if [ ! -d ".git" ]; then
    echo "Error: Not in a git repository"
    exit 1
fi

# Verify tests/.test_env exists
if [ ! -f "tests/.test_env" ]; then
    echo "Warning: tests/.test_env not found. Tests may fail."
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Create worktrees
for i in $(seq 1 $NUM_WORKTREES); do
    WORKTREE_PATH="${WORKTREE_BASE}_test${i}"
    BRANCH_NAME="test/${FEATURE_NAMES[$i-1]}"

    echo "Creating worktree ${i}/${NUM_WORKTREES}: ${WORKTREE_PATH}"
    git worktree add "${WORKTREE_PATH}" -b "${BRANCH_NAME}"

    # Create environment symlink if tests/.test_env exists
    if [ -f "tests/.test_env" ]; then
        echo "  → Creating tests/.test_env symlink"
        ln -s "${BASE_DIR}/tests/.test_env" "${WORKTREE_PATH}/tests/.test_env"
    fi

    # Create .env symlink as fallback
    if [ -f ".env" ]; then
        echo "  → Creating .env symlink"
        ln -s "${BASE_DIR}/.env" "${WORKTREE_PATH}/.env"
    fi
done

echo ""
echo "✓ Worktree setup complete!"
echo ""
echo "Worktree list:"
git worktree list

echo ""
echo "Next steps:"
echo "1. Open ${NUM_WORKTREES} terminal sessions"
echo "2. Navigate to each worktree directory"
echo "3. Start Claude Code in each session"
echo "4. Provide task instructions to each Claude Code"
```

### TASK.md Template

Each worktree should contain a TASK.md file with clear instructions:

```markdown
# Task N: [Brief Task Description]

## Your Mission
Implement this test from plan.md:
- [ ] Test: [Specific test requirement]

## What to Do

1. **Start Claude Code in THIS directory**
   ```bash
   cd /path/to/project_testN
   # Start your Claude Code session here
   ```

2. **Tell Claude to implement the test**
   ```
   I need to implement this test:
   [Test description]

   Follow TDD: Red → Green → Refactor
   [Additional context or requirements]

   Use /commit-behavioral when done.
   ```

3. **After completion**
   - Verify all tests pass: `uv run pytest -v -s`
   - Update plan.md checkbox to [x]
   - Commit with `/commit-behavioral`

## Test Details
- File: [test file path]
- Function name: [test function name]
- Expected behavior: [what the test should verify]

## Branch Info
- Branch: `test/feature-N`
- Worktree: `/path/to/project_testN`
- Parent: [parent branch name]
```

---

## Phase 2: Parallel Execution

### User Workflow

1. **Open N Terminal Sessions**

   ```bash
   # Terminal 1
   cd /path/to/project_test1
   cat TASK.md  # Review task
   # Start Claude Code session

   # Terminal 2
   cd /path/to/project_test2
   cat TASK.md
   # Start Claude Code session

   # Terminal 3-N...
   ```

2. **Provide Instructions to Each Claude Code**

   Copy the instructions from TASK.md or provide concise task description:

   ```
   Implement test: [test name]
   Follow TDD: Red → Green → Refactor
   Use /commit-behavioral when done
   ```

3. **Monitor Progress**

   - Watch test execution in each terminal
   - Verify each session completes successfully
   - Check that each branch has committed changes

4. **Verify Completion**

   ```bash
   # In each worktree
   git status  # Should be clean
   git log -1  # Should show recent commit
   uv run pytest -v -s  # All tests should pass
   ```

### Claude Code Workflow (in each session)

1. Read and understand the task from TASK.md
2. Implement test (Red phase)
3. Implement code to pass test (Green phase)
4. Refactor if needed
5. Run tests: `uv run pytest -v -s`
6. Update plan.md
7. Commit using `/commit-behavioral`

---

## Phase 3: Integration

### Sequential Merge Strategy

**⚠️ CRITICAL RULE: DO NOT use bulk integration or copy-paste approaches.**

Even when conflicts become complex:
1. NEVER abort merge and manually copy files
2. NEVER skip sequential merge process
3. ALWAYS resolve each conflict one by one
4. Each branch MUST be merged individually

**Why this matters:**
- Preserves git history
- Maintains individual contributions
- Enables feature-specific reverts
- Prevents future debugging confusion

**If tempted to abort:** Take a break, then continue with the current conflict resolution.

---

**Important:** Merge branches sequentially, not all at once. This allows you to:
- Resolve conflicts one at a time
- Identify which merge introduced issues
- Maintain clean git history

### Integration Process

```bash
# 1. Return to main working directory
cd /path/to/project_name

# 2. Verify clean state
git status
uv run pytest -v -s  # Baseline test run

# 3. Merge first branch
git merge test/feature-1 --no-edit

# If successful:
# 4. Merge second branch
git merge test/feature-2 --no-edit

# If conflict occurs:
# Resolve conflict (see Conflict Resolution section)
# Then continue with remaining branches

# 5. Continue until all branches merged
git merge test/feature-3 --no-edit
git merge test/feature-4 --no-edit

# 6. Run full test suite
uv run pytest -v -s

# 7. Verify all tests pass
# All tests should be green
```

### Automated Merge Script

```bash
#!/bin/bash
# merge_branches.sh - Sequential merge with conflict detection

set -e

BRANCHES=("test/feature-1" "test/feature-2" "test/feature-3" "test/feature-4")

echo "Starting sequential merge of ${#BRANCHES[@]} branches..."

for branch in "${BRANCHES[@]}"; do
    echo ""
    echo "Merging ${branch}..."

    if git merge "$branch" --no-edit; then
        echo "✓ ${branch} merged successfully"
    else
        echo "✗ Conflict detected in ${branch}"
        echo ""
        echo "Please resolve conflicts manually:"
        echo "  1. Edit conflicted files"
        echo "  2. git add <resolved-files>"
        echo "  3. git commit"
        echo "  4. Run this script again to continue"
        exit 1
    fi
done

echo ""
echo "✓ All branches merged successfully!"
echo ""
echo "Running full test suite..."
uv run pytest -v -s

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ All tests passed!"
else
    echo ""
    echo "✗ Tests failed. Review and fix before proceeding."
    exit 1
fi
```

### Conflict Resolution

#### Common Conflict Patterns

**1. plan.md Conflicts**

**Symptom:**
```
<<<<<<< HEAD
- [x] Test: Feature A
- [ ] Test: Feature B
=======
- [ ] Test: Feature A
- [x] Test: Feature B
>>>>>>> test/feature-2
```

**Resolution:**
Mark both as completed:
```
- [x] Test: Feature A
- [x] Test: Feature B
```

**2. Test File Conflicts**

**Symptom:**
```python
<<<<<<< HEAD
def test_feature_a():
    assert feature_a() == True
=======
def test_feature_b():
    assert feature_b() == True
>>>>>>> test/feature-2
```

**Resolution:**
Include both test functions:
```python
def test_feature_a():
    assert feature_a() == True


def test_feature_b():
    assert feature_b() == True
```

**3. Implementation File Conflicts**

**Symptom:**
```python
<<<<<<< HEAD
    # Feature A implementation
    if condition_a:
        return result_a
=======
    # Feature B implementation
    if condition_b:
        return result_b
>>>>>>> test/feature-2
```

**Resolution:**
This requires careful analysis. Options:
- Combine both implementations if compatible
- Refactor to support both features
- Ask user for clarification if unclear

#### Conflict Resolution Process

```bash
# 1. Identify conflicted files
git status

# 2. For each conflicted file:
#    - Open in editor
#    - Resolve conflicts
#    - Save file

# 3. Stage resolved files
git add <resolved-files>

# 4. Complete the merge
git commit -m "Merge branch 'test/feature-N' with conflict resolution"

# 5. Continue with remaining merges
git merge test/feature-next --no-edit
```

### Verification

After all merges complete:

```bash
# 1. Check git status
git status  # Should be clean

# 2. Run full test suite
uv run pytest -v -s

# 3. Review commit history
git log --oneline --graph -10

# 4. Check branch status
git branch --merged
```

---

## Phase 4: Cleanup

### Manual Cleanup

```bash
# 1. Remove worktrees
git worktree remove ../project_name_test1 --force
git worktree remove ../project_name_test2 --force
git worktree remove ../project_name_test3 --force
git worktree remove ../project_name_test4 --force

# 2. Delete merged branches
git branch -d test/feature-1 test/feature-2 test/feature-3 test/feature-4

# 3. Verify cleanup
git worktree list  # Should only show main directory
git branch  # Merged branches should be gone

# 4. Push to remote
git push origin <branch-name>
```

### Automated Cleanup Script

```bash
#!/bin/bash
# cleanup_worktrees.sh - Remove worktrees and branches

set -e

PROJECT_NAME="${PWD##*/}"
WORKTREE_BASE="../${PROJECT_NAME}"
NUM_WORKTREES=4
BRANCHES=("test/feature-1" "test/feature-2" "test/feature-3" "test/feature-4")

echo "Cleaning up ${NUM_WORKTREES} worktrees..."

# Remove worktrees
for i in $(seq 1 $NUM_WORKTREES); do
    WORKTREE_PATH="${WORKTREE_BASE}_test${i}"

    if [ -d "${WORKTREE_PATH}" ]; then
        echo "Removing worktree: ${WORKTREE_PATH}"
        git worktree remove "${WORKTREE_PATH}" --force
    else
        echo "Worktree not found (already removed?): ${WORKTREE_PATH}"
    fi
done

# Delete branches
echo ""
echo "Deleting merged branches..."
git branch -d "${BRANCHES[@]}"

echo ""
echo "✓ Cleanup complete!"
echo ""
echo "Current worktrees:"
git worktree list

echo ""
echo "Remaining branches:"
git branch
```

---

## Real-World Example: ClickHouse Toolset Tests

### Scenario

**Task:** Implement 4 ClickHouse period enforcement tests in parallel
**Date:** 2025-11-13
**Project:** helix_adk

### Test Requirements

1. Test: query_with_enforcement rejects 2018-12-31 for allowed_period="backtest"
2. Test: query_with_enforcement accepts 2019-2023 for allowed_period="backtest"
3. Test: SQL injection attempt gets blocked
4. Test: INSERT/UPDATE/DELETE queries rejected

### Execution Timeline

| Phase | Duration | Details |
|-------|----------|---------|
| Setup | 2 min | Created 4 worktrees, branches, TASK.md files |
| Parallel Execution | 7 min | 4 tests implemented simultaneously |
| Integration | 3 min | Merged all branches, resolved conflicts |
| Cleanup | 1 min | Removed worktrees, deleted branches |
| **Total** | **13 min** | **vs. ~28 min sequential** |

### Detailed Steps

#### 1. Setup Phase

```bash
# Main directory: /Users/alphabridge/Documents/Git/helix_adk
# Branch: feature/initial-setup
# Starting commit: 6975a28

# Created worktrees
git worktree add ../helix_adk_test1 -b test/backtest-2018-reject
git worktree add ../helix_adk_test2 -b test/backtest-2019-accept
git worktree add ../helix_adk_test3 -b test/sql-injection-block
git worktree add ../helix_adk_test4 -b test/dml-reject

# Created TASK.md in each worktree with specific test requirements

# Setup environment symlinks (if needed)
ln -s $(pwd)/tests/.test_env ../helix_adk_test1/tests/.test_env
ln -s $(pwd)/tests/.test_env ../helix_adk_test2/tests/.test_env
ln -s $(pwd)/tests/.test_env ../helix_adk_test3/tests/.test_env
ln -s $(pwd)/tests/.test_env ../helix_adk_test4/tests/.test_env
```

#### 2. Parallel Execution

**Terminal 1** (test/backtest-2018-reject):
```bash
cd ../helix_adk_test1
# Claude Code implemented:
# - test_should_reject_2018_date_for_backtest_period()
# - Verified 2018-12-31 rejected for backtest period
# - Committed: fc1462c
```

**Terminal 2** (test/backtest-2019-accept):
```bash
cd ../helix_adk_test2
# Claude Code implemented:
# - test_should_accept_2019_2023_dates_for_backtest_period()
# - Verified 2019-2023 dates accepted for backtest period
# - Committed: a37f572
```

**Terminal 3** (test/sql-injection-block):
```bash
cd ../helix_adk_test3
# Claude Code implemented:
# - test_should_block_sql_injection_attempts()
# - Added _detect_sql_injection() function
# - Verified SQL injection patterns blocked
# - Committed: cdb6a42
```

**Terminal 4** (test/dml-reject):
```bash
cd ../helix_adk_test4
# Claude Code implemented:
# - test_should_reject_dml_queries()
# - Added DML/DDL keyword detection
# - Verified INSERT/UPDATE/DELETE rejected
# - Committed: 30adcfe
```

#### 3. Integration Phase

```bash
# Returned to main directory
cd /Users/alphabridge/Documents/Git/helix_adk

# Merge 1: test/backtest-2018-reject
git merge test/backtest-2018-reject --no-edit
# Result: Fast-forward (no conflict)

# Merge 2: test/backtest-2019-accept
git merge test/backtest-2019-accept --no-edit
# Result: CONFLICT in plan.md and test file

# Conflict Resolution:
# File: plan.md
# Issue: Both branches marked different tests as completed
# Solution: Marked both as [x]

# File: tests/test_period_enforcement.py
# Issue: Both branches added different test functions at same location
# Solution: Included both test functions

git add plan.md tests/test_period_enforcement.py
git commit -m "Merge branch 'test/backtest-2019-accept'"

# Merge 3: test/sql-injection-block
git merge test/sql-injection-block --no-edit
# Result: Success (no conflict)

# Merge 4: test/dml-reject
git merge test/dml-reject --no-edit
# Result: CONFLICT in src/tools/clickhouse_toolset.py

# Conflict Resolution:
# File: src/tools/clickhouse_toolset.py
# Issue: Both branches added validation code at same location
# Solution: Included both SQL injection check AND DML rejection check

git add src/tools/clickhouse_toolset.py tests/test_period_enforcement.py plan.md
git commit -m "Merge branch 'test/dml-reject'"

# Run full test suite
uv run pytest -v -s
# Result: 34 tests passed in 4.25s ✓
```

#### 4. Cleanup Phase

```bash
# Remove worktrees
git worktree remove ../helix_adk_test1 --force
git worktree remove ../helix_adk_test2 --force
git worktree remove ../helix_adk_test3 --force
git worktree remove ../helix_adk_test4 --force

# Delete branches
git branch -d test/backtest-2018-reject
git branch -d test/backtest-2019-accept
git branch -d test/sql-injection-block
git branch -d test/dml-reject

# Push to remote
git push origin feature/initial-setup
# Result: 13 commits pushed successfully
```

### Final Results

**Commits Created:**
```
0afc087 fix: Remove merge conflict marker from test file
7a6b0ee Merge branch 'test/dml-reject'
01305b3 Merge branch 'test/sql-injection-block'
f7dbbc7 Merge branch 'test/backtest-2019-accept'
fc1462c test: Add backtest period enforcement test for 2018
a37f572 test: Add backtest period acceptance test for 2019-2023
cdb6a42 feat: Add SQL injection detection
30adcfe feat: Add DML/DDL query rejection
```

**Test Coverage:**
- Before: 30 tests
- After: 34 tests (+4)
- All tests passing: ✓

**Time Saved:**
- Sequential estimate: 28 minutes (7 min × 4 tests)
- Parallel actual: 13 minutes (setup + parallel + integration)
- **Efficiency gain: 54%**

---

## Troubleshooting

### Issue: Environment File Not Found

**Symptom:**
```
ValueError: ClickHouse connection not configured
```

**Cause:** Worktree doesn't have access to .env or tests/.test_env

**Solution:**
```bash
# Create symlink to test environment file
ln -s $(pwd)/tests/.test_env ../project_name_testN/tests/.test_env

# Or create symlink to main .env
ln -s $(pwd)/.env ../project_name_testN/.env

# Verify symlink created
ls -la ../project_name_testN/tests/.test_env
```

### Issue: Worktree Remove Fails

**Symptom:**
```
fatal: '../project_name_test1' contains modified or untracked files, use --force to delete it
```

**Cause:** Uncommitted changes in worktree

**Solution:**
```bash
# Option 1: Force remove (discard changes)
git worktree remove ../project_name_test1 --force

# Option 2: Commit changes first
cd ../project_name_test1
git add .
git commit -m "WIP: Changes before worktree removal"
cd -
git worktree remove ../project_name_test1
```

### Issue: Merge Conflicts Unclear

**Symptom:** Can't determine which version to keep

**Solution:**
```bash
# 1. Abort current merge
git merge --abort

# 2. Merge with more verbose output
git merge test/feature-N --no-ff -v

# 3. Examine both versions
git show HEAD:path/to/file  # Current version
git show test/feature-N:path/to/file  # Incoming version

# 4. Use merge tool
git mergetool

# 5. Or ask user for guidance
```

### Issue: Test Failures After Merge

**Symptom:** Tests pass individually but fail after merge

**Cause:** Feature interactions not tested in isolation

**Solution:**
```bash
# 1. Identify failing tests
uv run pytest -v -s --tb=short

# 2. Check for naming conflicts
grep -r "def test_.*" tests/

# 3. Examine merged code for conflicts
git diff HEAD~4..HEAD

# 4. Fix conflicts and re-test
# Edit conflicting files
uv run pytest -v -s

# 5. Commit fixes
git add .
git commit -m "fix: Resolve test failures after merge"
```

### Issue: Branch Already Exists

**Symptom:**
```
fatal: A branch named 'test/feature-1' already exists
```

**Cause:** Previous worktree session wasn't cleaned up

**Solution:**
```bash
# List all worktrees
git worktree list

# Remove old worktree if exists
git worktree remove ../project_name_test1 --force

# Delete old branch
git branch -D test/feature-1

# Now create new worktree
git worktree add ../project_name_test1 -b test/feature-1
```

---

## Best Practices

### Planning

1. **Identify Independent Tasks**: Ensure tasks don't depend on each other
2. **Estimate Complexity**: Balance task complexity across worktrees
3. **Verify Prerequisites**: All tasks should have same starting point
4. **Document Clearly**: Write detailed TASK.md for each worktree

### Execution

1. **Setup Environment First**: Create symlinks before starting work
2. **Monitor Progress**: Check on each terminal periodically
3. **Commit Frequently**: Each worktree should commit independently
4. **Run Tests**: Verify tests pass in each worktree before merging

### Integration

1. **Merge Sequentially**: One branch at a time, not all at once
2. **Test After Each Merge**: Catch issues early
3. **Resolve Conflicts Immediately**: Don't continue merging with unresolved conflicts
4. **Verify Final State**: Run full test suite after all merges

### Cleanup

1. **Don't Skip Cleanup**: Leftover worktrees can cause confusion
2. **Verify Before Pushing**: Run tests one final time
3. **Document Issues**: Note any problems for future reference

---

## Automation Scripts Summary

All scripts are provided in this document. To use them:

### Setup Script
```bash
# Save as: scripts/setup_worktrees.sh
chmod +x scripts/setup_worktrees.sh
./scripts/setup_worktrees.sh
```

### Merge Script
```bash
# Save as: scripts/merge_branches.sh
chmod +x scripts/merge_branches.sh
./scripts/merge_branches.sh
```

### Cleanup Script
```bash
# Save as: scripts/cleanup_worktrees.sh
chmod +x scripts/cleanup_worktrees.sh
./scripts/cleanup_worktrees.sh
```

---

## Conclusion

Git worktree parallel workflow enables efficient parallel development with proper isolation and clean git history. This guide provides Claude Code with:

- Complete workflow understanding
- Step-by-step instructions
- Environment setup strategies
- Conflict resolution patterns
- Real-world example
- Troubleshooting guide
- Automation scripts

By following this workflow, development time can be reduced by 50-70% for independent parallel tasks while maintaining code quality and test coverage.

---

**Document Version:** 1.0
**Last Updated:** 2025-11-13
**Maintained By:** Claude Code + User Collaboration
