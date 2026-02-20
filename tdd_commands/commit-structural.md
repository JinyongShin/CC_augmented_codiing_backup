---
description: Commit structural changes (Tidy First - no behavior changes)
---

# Commit Structural - Structural Changes Only

You are now executing the `/commit-structural` command to commit structural changes.

## Your Task

Create a commit for STRUCTURAL changes only, following Tidy First principles.

## Pre-Commit Verification

**CRITICAL**: Before committing, verify:

1. ✅ **ALL tests pass**: `pytest -v -s`
2. ✅ **No linter warnings**: Check for any code quality issues
3. ✅ **Changes are purely structural**:
   - Renaming (variables, functions, classes)
   - Extracting methods
   - Moving code
   - Reformatting
   - Reorganizing
   - **NO behavior changes**
4. ✅ **Behavior unchanged**: Tests prove this

## Process

1. **Run all tests** to confirm they pass
2. **Show git status** and **git diff** to review changes
3. **Verify changes are structural only**
4. **Create commit** with clear structural commit message
5. **Confirm commit created**

## Commit Message Format

```
structural: [Brief description of structural change]

- [Detail about what was changed structurally]
- [Why this improves code structure]

All tests passing. No behavior changes.
```

## Examples

✅ GOOD (Structural):
```
structural: Extract validation logic into separate method

- Extracted email validation from User class into validate_email()
- Improves code readability and reusability

All tests passing. No behavior changes.
```

❌ BAD (Mixed structural + behavioral):
```
structural: Rename function and fix bug

- Renamed processData to process_user_data
- Fixed off-by-one error in loop  ← This is behavioral!
```

## If Changes Are NOT Structural

If you detect behavioral changes:
- **STOP** and inform the user
- Suggest using `/commit-behavioral` instead
- Or suggest separating the changes

## Output Format

```
📋 Structural Commit Review

Running tests...
[test results]

Git status:
[show changes]

Changes verification:
✅ All changes are structural
✅ No behavior modifications
✅ All tests passing

Commit message:
[show proposed commit message]

Creating commit...
[commit output]

✅ Structural changes committed successfully
```

Now verify and create the structural commit.
