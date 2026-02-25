# Navigation Commands

## /tdd next

Show the next unmarked test from `plan.md` without executing it.
Display: test description, position (Test X of Y), remaining count.
Do NOT execute anything.

---

## /tdd status

Show comprehensive TDD status.

1. Read `plan.md` for progress (total, completed, remaining, percentage).
2. Run `pytest -v -s` to determine current phase:
   - **RED**: Tests are failing (writing a new test)
   - **GREEN**: All tests pass (just made tests pass)
   - **REFACTOR**: All tests pass, code could be improved
   - **READY**: No test in progress, ready for next
3. Show current test, warnings (failing tests, uncommitted changes), and suggested next action.

---

## /tdd mark

Mark the current (first unmarked) test as completed.

Before marking, verify:
- All tests pass (`pytest -v -s`)
- The TDD cycle (Red -> Green -> Refactor) was completed
- No linter warnings exist

If verification fails, report what needs fixing instead of marking.

After marking, show progress: `X of Y tests completed (Z%)` and the next test.

---

## /tdd test-run

Run all tests with verbose output.

```bash
pytest -v -s
```

Show: full output, pass/fail counts, execution time, and current phase suggestion.
