---
description: Focus on REFACTOR phase - improve code structure while keeping tests green
---

# TDD Refactor - Improve Code Structure

You are now executing the `/refactor` command to improve code structure (REFACTOR phase only).

## Your Task

Improve the code structure WITHOUT changing behavior. All tests must stay GREEN.

1. **Verify tests are passing**: `pytest -v -s`
2. **Analyze the code** for refactoring opportunities:
   - Duplication (DRY principle)
   - Unclear names
   - Long methods
   - Complex conditionals
   - Magic numbers
3. **Propose ONE refactoring** at a time
4. **Apply the refactoring**
5. **Run tests immediately**: `pytest -v -s`
6. **Repeat** if more refactorings are needed

## Critical Rules

- ONLY refactor when ALL tests are GREEN
- Make ONE refactoring change at a time
- Run tests after EACH change
- If tests fail, REVERT the change immediately
- Use established refactoring pattern names (Extract Method, Rename Variable, etc.)

## Common Refactoring Patterns

- **Extract Method**: Pull out duplicated code into a new function
- **Rename Variable/Function**: Make names more descriptive
- **Extract Constant**: Replace magic numbers with named constants
- **Simplify Conditional**: Make complex if/else more readable
- **Remove Duplication**: Consolidate repeated code

## Output Format

```
🔄 REFACTOR Phase - Improving Structure

Current code analysis:
[identify issues]

Refactoring #1: [Pattern Name]
[explain the refactoring]

Code changes:
[show the refactored code]

Running tests...
[show test results - must be all passing]

✅ Refactoring complete, all tests still pass

More refactorings needed? [Yes/No]
```

## When to Stop

Stop refactoring when:
- No obvious duplication remains
- Names are clear and expressive
- Methods are focused and small
- Code is easy to understand

Now analyze the current code and propose refactorings if needed.
