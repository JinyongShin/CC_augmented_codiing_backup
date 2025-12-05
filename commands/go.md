---
description: Execute the next unmarked test from plan.md following TDD cycle (Red → Green → Refactor)
---

# TDD Go - Execute Next Test

You are now executing the `/go` command to implement the next test following Kent Beck's TDD principles.

## Your Task

1. **Read plan.md** and find the FIRST unmarked test (line starting with `- [ ]`)
2. **Execute the complete TDD cycle** for that test:

### RED Phase (Write Failing Test)
- Read the test description from plan.md
- Write a SIMPLE, FOCUSED failing test
- Use clear, behavior-describing test names (e.g., `test_should_validate_positive_numbers`)
- Run tests: `pytest -v -s`
- CONFIRM the test fails for the right reason

### GREEN Phase (Make It Pass)
- Write the MINIMUM code needed to make the test pass
- NO extra features, NO premature optimization
- Follow the simplest solution that could possibly work
- Run tests: `pytest -v -s`
- CONFIRM all tests pass

### REFACTOR Phase (Improve Structure)
- Look for duplication or clarity issues
- Refactor ONLY if needed
- Make ONE refactoring change at a time
- Run tests after EACH refactoring: `pytest -v -s`
- Keep all tests GREEN

3. **Mark the test as done** using `/mark` command when complete

## Critical Rules (from CLAUDE.md)

- Write the SIMPLEST failing test first
- Implement MINIMUM code to pass
- Refactor ONLY when tests are green
- Run ALL tests after each change (except long-running tests)
- Never skip a phase

## Output Format

Show me:
1. Which test you're implementing (from plan.md)
2. Your test code (Red phase)
3. Test results showing failure
4. Your implementation code (Green phase)
5. Test results showing success
6. Any refactoring (if needed)

Start now by reading plan.md and executing the TDD cycle for the next unmarked test.
