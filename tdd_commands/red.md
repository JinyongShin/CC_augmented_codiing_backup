---
description: Focus on RED phase - write a failing test only
---

# TDD Red - Write Failing Test

You are now executing the `/red` command to write a failing test (RED phase only).

## Your Task

Write ONLY a failing test. Do NOT implement the solution yet.

1. **Read plan.md** and identify the current test to implement
2. **Write a simple, focused failing test** that:
   - Has a clear, behavior-describing name (e.g., `test_should_reject_negative_input`)
   - Tests ONE specific behavior
   - Is the simplest test that could fail
   - Has clear assertions
3. **Run the test** to confirm it fails: `pytest -v -s`
4. **Verify it fails for the RIGHT reason** (not syntax error, import error, etc.)

## Critical Rules

- Keep the test SIMPLE - test one thing
- Use meaningful names that describe the expected behavior
- Make the failure message clear
- Do NOT write implementation code yet
- Do NOT write multiple tests at once

## Output Format

```
🔴 RED Phase - Writing Failing Test

Test: [test name and description]

Code:
[show the test code]

Running tests...
[show test output with failure]

✅ Test fails for the correct reason: [explain why it's failing]

Next: Use /green to implement the minimum code to make this test pass
```

Now read plan.md and write a failing test for the current unmarked item.
