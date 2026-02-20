---
description: Show TDD cycle status and progress
---

# TDD Status - Progress Overview

You are now executing the `/status` command to show the current TDD status.

## Your Task

1. **Read plan.md** and analyze progress
2. **Run tests** to determine current phase: `pytest -v -s`
3. **Display comprehensive status**

## Status Information to Show

### 📊 Progress Summary
- Total tests in plan
- Completed tests ([x])
- Remaining tests ([ ])
- Completion percentage

### 🔄 Current TDD Phase
Determine the current phase based on:
- **RED**: Last test run failed (expected - writing failing test)
- **GREEN**: All tests passing (just made tests pass)
- **REFACTOR**: All tests passing + code could be improved
- **READY**: No test in progress, ready for next test

### 📋 Current Test
- Show the current unmarked test (if any)
- Or show "All tests complete!"

### ⚠️ Warnings (if any)
- Failing tests (if not in RED phase)
- Linter warnings
- Uncommitted changes

## Output Format

```
📊 TDD Status Report

Progress: X/Y tests complete (Z%)
[████████░░]

🔄 Current Phase: [RED | GREEN | REFACTOR | READY]

📋 Current Test:
- [ ] Test description

✅ Test Status: X passing, Y failed

⚠️ Warnings: [None | List warnings]

Next Action:
- Use /go to continue
- Use /next to preview next test
```

Read plan.md, run tests, and show me the current status.
