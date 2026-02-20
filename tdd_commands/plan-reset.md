---
description: Reset all test marks in plan.md (use with caution)
---

# Plan Reset - Reset All Test Marks

You are now executing the `/plan-reset` command to reset all test completion marks.

## ⚠️ WARNING

This command will change ALL completed tests `[x]` back to unmarked `[ ]`.

**This is a destructive operation and should be used with caution.**

## Your Task

1. **Confirm with the user** before proceeding:
   - Show how many tests will be reset
   - Ask for explicit confirmation
2. **If confirmed**:
   - Read plan.md
   - Replace all `[x]` with `[ ]`
   - Update plan.md
   - Show confirmation
3. **If not confirmed**:
   - Cancel the operation

## Confirmation Format

```
⚠️ Plan Reset Confirmation

Current status:
- Total tests: X
- Completed [x]: Y
- Unmarked [ ]: Z

This will reset ALL Y completed tests to unmarked.

Are you sure you want to proceed? (yes/no)
```

## After Reset Format (if confirmed)

```
✅ Plan Reset Complete

All tests have been reset to unmarked.

New status:
- Total tests: X
- Completed [x]: 0
- Unmarked [ ]: X

Use /plan-view to see the updated plan
Use /go to start fresh
```

## Use Cases

This command is useful when:
- Starting a new iteration of the same tests
- Practicing TDD on the same feature set
- Resetting after a major refactoring

First, show me the current plan status and ask for confirmation.
