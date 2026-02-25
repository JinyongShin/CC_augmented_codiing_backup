# Planning Commands

## /tdd plan-init

Create a new `plan.md` file in the project root to start TDD development.

1. Check if `plan.md` already exists. If so, warn the user and ask for confirmation before overwriting.
2. Ask the user what feature/module they want to develop.
3. Read the template from `references/plan-template.md` in this skill's directory.
4. Customize the template: replace `[Feature Name]` with the user's feature name and remove example tests.
5. Ask the user for their initial test list (or help them brainstorm tests based on requirements).
6. Write `plan.md` with the tests in `- [ ]` format.
7. Show the created plan with statistics.

Output:
```
📝 Plan Initialized

Created plan.md with X tests for [Feature Name]

Tests:
- [ ] Test 1: ...
- [ ] Test 2: ...

Use /tdd go to start the TDD cycle
Use /tdd plan-add to add more tests
```

---

## /tdd plan-view

Display the full test plan with statistics.

1. Read `plan.md` from the project root.
2. Display its complete contents.
3. Show statistics: total tests, completed `[x]`, remaining `[ ]`, progress percentage.

---

## /tdd plan-add [description]

Add a new test to `plan.md`.

1. If description is provided as argument, use it. Otherwise ask the user.
2. Read current `plan.md`.
3. Append the new test as `- [ ]` at the end of the Tests section.
4. Show updated statistics.

---

## /tdd plan-reset

Reset all test marks. This is destructive - confirm before proceeding.

1. Read `plan.md` and count completed tests.
2. Show current status and ask for explicit confirmation.
3. If confirmed, replace all `[x]` with `[ ]`.
4. Show updated status.
