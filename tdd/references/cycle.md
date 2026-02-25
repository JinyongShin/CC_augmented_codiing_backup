# TDD Cycle Commands

## /tdd go

Execute the complete TDD cycle for the next unmarked test. This is the main workhorse command.

1. Read `plan.md` and find the first `- [ ]` test.
2. Execute the full cycle:

### RED Phase
- Write a simple, focused failing test based on the test description.
- Use behavior-describing names (e.g., `test_should_validate_positive_numbers`).
- Run `pytest -v -s` and confirm the test fails for the right reason (not import/syntax errors).

### GREEN Phase
- Write the minimum code to make the test pass. No extra features, no premature optimization.
- Hard-code values if that's the simplest path - generalize later if needed.
- Run `pytest -v -s` and confirm ALL tests pass.

### REFACTOR Phase
- Look for duplication, unclear names, long methods.
- Refactor only if genuinely needed. Make one change at a time.
- Run tests after each refactoring step.

3. After the cycle, mark the test as done (change `[ ]` to `[x]`).
4. Show what was implemented and test results.

---

## /tdd red

RED phase only - write a failing test without implementing the solution.

1. Read `plan.md` and identify the current test.
2. Write one simple, focused failing test that tests one specific behavior.
3. Run `pytest -v -s` and verify it fails for the right reason.
4. Do NOT write implementation code.

Output format:
```
🔴 RED Phase - Writing Failing Test
Test: [name and description]
Code: [test code]
Result: Test fails ✅ - [reason]
Next: Use /tdd green to implement
```

---

## /tdd green

GREEN phase only - write minimum code to make failing tests pass.

1. Run `pytest -v -s` to see current failures.
2. Implement the simplest solution that makes the test pass.
   - No extra features, no "what if" scenarios.
   - Prefer obvious solutions over clever ones.
3. Run `pytest -v -s` and verify ALL tests pass.
4. Do NOT refactor yet.

Example of minimum code:
- If test only checks addition, write `def calculate(x, y): return x + y`
- Do NOT add operation parameter, error handling, or other untested features.

Output format:
```
🟢 GREEN Phase - Making Tests Pass
Failing test: [name]
Implementation: [minimal code]
Result: All tests pass ✅
Next: Use /tdd refactor if needed, or /tdd mark to complete
```

---

## /tdd refactor

REFACTOR phase only - improve code structure while keeping all tests green.

1. Verify all tests pass first: `pytest -v -s`
2. Analyze code for: duplication, unclear names, long methods, complex conditionals, magic numbers.
3. Apply one refactoring at a time using named patterns:
   - Extract Method, Rename Variable/Function, Extract Constant, Simplify Conditional, Remove Duplication
4. Run tests after each change. If tests fail, revert immediately.
5. Stop when: no duplication remains, names are clear, methods are small and focused.
