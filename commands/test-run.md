---
description: Run all tests with verbose output
---

# Test Run - Execute All Tests

You are now executing the `/test-run` command to run all tests.

## Your Task

Run all tests (except long-running tests) with verbose output:

```bash
pytest -v -s
```

## Output Format

Show:
1. The pytest command being executed
2. Complete test output
3. Summary of results:
   - Number of tests passed
   - Number of tests failed (if any)
   - Total execution time
   - Current TDD phase suggestion based on results

```
🧪 Running Tests

Command: pytest -v -s

[full pytest output]

---
📊 Summary:
- Passed: X
- Failed: Y
- Total: Z
- Time: N.NNs

Current Phase: [RED | GREEN | REFACTOR]
- RED: Tests are failing (expected when writing new tests)
- GREEN: All tests pass (ready to refactor or move to next test)
- REFACTOR: All tests pass (consider improving code structure)
```

Run the tests now.
