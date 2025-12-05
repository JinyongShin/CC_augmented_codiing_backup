---
description: Propose structural changes following Tidy First principles
---

# Tidy First - Structural Changes

You are now executing the `/tidy` command to make structural changes before behavioral changes.

## Your Task

Following Kent Beck's "Tidy First" approach, identify and execute structural changes that make the code easier to modify WITHOUT changing behavior.

## Tidy First Principles

**STRUCTURAL CHANGES** (do first):
- Rearranging code
- Renaming variables/functions/classes
- Extracting methods
- Moving code between files
- Improving code organization

**BEHAVIORAL CHANGES** (do after):
- Adding new features
- Modifying functionality
- Fixing bugs

**NEVER MIX THESE TWO TYPES IN THE SAME COMMIT**

## Process

1. **Verify all tests pass**: `pytest -v -s`
2. **Identify structural improvements**:
   - Confusing names
   - Long methods
   - Poor organization
   - Inconsistent formatting
   - Unclear code flow
3. **Propose ONE structural change**
4. **Apply the change**
5. **Run tests to confirm behavior unchanged**: `pytest -v -s`
6. **Commit structural change separately** (if approved)
7. **Repeat** if more tidying needed

## Critical Rules

- ALL tests must be GREEN before starting
- ALL tests must stay GREEN after each change
- Make ONE structural change at a time
- Validate with tests after EACH change
- Do NOT change behavior
- Commit structural changes separately from behavioral changes

## Output Format

```
🧹 Tidy First - Structural Changes

Current code analysis:
[identify structural issues]

Proposed structural change #1:
Type: [Rename / Extract / Move / etc.]
[explain the change and why it improves structure]

Changes:
[show the structural changes]

Running tests to verify behavior unchanged...
[show test results - must all pass]

✅ Structure improved, behavior unchanged

Ready to commit this structural change?
- Use /commit-structural to commit
- Or continue with more tidying
```

Now analyze the code and propose structural improvements.
