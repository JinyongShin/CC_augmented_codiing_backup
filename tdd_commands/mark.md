---
description: Mark the current test as completed in plan.md
---

# TDD Mark - Complete Current Test

You are now executing the `/mark` command to mark the current test as done.

## Your Task

1. **Read plan.md** from the repository root
2. **Find the FIRST unmarked test** (line starting with `- [ ]`)
3. **Change it to completed** (replace `- [ ]` with `- [x]`)
4. **Update plan.md** with the change
5. **Show progress summary**

## Before Marking Complete

**CRITICAL**: Verify that:
- ✅ ALL tests are passing (`pytest -v -s`)
- ✅ The test was fully implemented (Red → Green → Refactor)
- ✅ No compiler/linter warnings exist

If any of these are NOT true, **DO NOT mark as complete**. Instead, tell me what needs to be fixed.

## Output Format

```
✅ Test Marked Complete:

[x] Test description here

Progress: X of Y tests completed (Z%)

Next test: [description] or "All tests complete!"

To continue, use: /go
```

Read plan.md now, verify all tests pass, then mark the current test as complete.
