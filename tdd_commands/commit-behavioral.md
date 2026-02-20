---
description: Commit behavioral changes (new features, bug fixes, functionality changes)
---

# Commit Behavioral - Behavioral Changes Only

You are now executing the `/commit-behavioral` command to commit behavioral changes.

## Your Task

Create a commit for BEHAVIORAL changes only, following Tidy First principles.

## Pre-Commit Verification

**CRITICAL**: Before committing, verify:

1. ✅ **ALL tests pass**: `pytest -v -s`
2. ✅ **No linter warnings**: Check for any code quality issues
3. ✅ **Changes modify behavior**:
   - New features
   - Bug fixes
   - Modified functionality
   - New tests for new behavior
4. ✅ **TDD cycle complete**: Red → Green → Refactor
5. ✅ **No mixed structural changes**: If present, commit those separately first

## Process

1. **Run all tests** to confirm they pass
2. **Show git status** and **git diff** to review changes
3. **Verify changes are behavioral**
4. **Create commit** with clear behavioral commit message
5. **Confirm commit created**

## Commit Message Format

```
feat|fix|test: [Brief description of behavioral change]

- [Detail about what behavior was added/changed]
- [What problem this solves]

TDD cycle complete. All tests passing.
```

Use conventional commit prefixes:
- `feat:` for new features
- `fix:` for bug fixes
- `test:` for adding missing tests

## Examples

✅ GOOD (Behavioral):
```
feat: Add email validation to User registration

- Implemented validate_email() function
- Added tests for valid and invalid email formats
- User.register() now validates email before saving

TDD cycle complete. All tests passing.
```

✅ GOOD (Behavioral - Bug Fix):
```
fix: Correct off-by-one error in pagination

- Fixed loop boundary in paginate() function
- Added test to verify correct page boundaries
- Resolves incorrect last page handling

TDD cycle complete. All tests passing.
```

❌ BAD (Mixed structural + behavioral):
```
feat: Add validation and rename methods

- Added email validation  ← Behavioral
- Renamed processData to process_user_data  ← Structural!
```

## If Changes Include Structural Changes

If you detect structural changes mixed in:
- **STOP** and inform the user
- Suggest committing structural changes first with `/commit-structural`
- Then commit behavioral changes separately

## Output Format

```
📋 Behavioral Commit Review

Running tests...
[test results]

Git status:
[show changes]

Changes verification:
✅ Changes modify behavior (new feature/fix)
✅ TDD cycle complete
✅ All tests passing

Commit message:
[show proposed commit message]

Creating commit...
[commit output]

✅ Behavioral changes committed successfully
```

Now verify and create the behavioral commit.
