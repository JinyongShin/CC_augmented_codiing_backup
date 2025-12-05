---
description: Focus on GREEN phase - write minimum code to pass tests
---

# TDD Green - Make Tests Pass

You are now executing the `/green` command to make the failing test pass (GREEN phase only).

## Your Task

Write the MINIMUM code needed to make the test pass. Nothing more.

1. **Run tests first** to see current failures: `pytest -v -s`
2. **Implement the simplest solution** that makes the test pass:
   - No extra features
   - No premature optimization
   - No "what if" scenarios
   - Just enough to turn the test green
3. **Run tests again** to confirm they pass: `pytest -v -s`
4. **Verify ALL tests pass** (not just the new one)

## Critical Rules

- Write the SIMPLEST code that could possibly work
- Avoid clever solutions - prefer obvious ones
- Hard-code values if that makes the test pass (we'll generalize later if needed)
- Do NOT add features not required by tests
- Do NOT refactor yet - that comes next

## Examples of "Minimum Code"

❌ TOO MUCH:
```python
def calculate(x, y, operation='add'):
    if operation == 'add':
        return x + y
    elif operation == 'subtract':
        return x - y
    # ... more operations
```

✅ JUST ENOUGH (if test only checks addition):
```python
def calculate(x, y):
    return x + y
```

## Output Format

```
🟢 GREEN Phase - Making Tests Pass

Current failing test: [test name]

Implementation:
[show the minimal code]

Running all tests...
[show test output with all passing]

✅ All tests pass

Next: Use /refactor if code needs improvement, or /mark to complete this test
```

Now implement the minimum code to make the failing test pass.
