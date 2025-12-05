---
description: Add a new test to plan.md
---

# Plan Add - Add New Test

You are now executing the `/plan-add` command to add a new test to the plan.

## Your Task

The user wants to add a new test to plan.md. Help them by:

1. **Ask for the test description** (if not provided)
2. **Read current plan.md** to see existing tests
3. **Add the new test** in the appropriate location:
   - Add to the end of the Tests section
   - Use `- [ ]` format (unmarked)
   - Follow the same format as existing tests
4. **Update plan.md** with the new test
5. **Show confirmation** with updated statistics

## Output Format

```
➕ Adding New Test to Plan

Test to add: [description]

Updated plan.md:
[show relevant section]

---
📊 Updated Statistics:
- Total tests: X (was Y)
- Completed: N
- Remaining: M

Use /plan-view to see the full plan
Use /go to start working on tests
```

## Notes

- If the user provides a test description with the command (e.g., `/plan-add Should validate user input`), use that
- Otherwise, ask the user for the test description
- Maintain consistent formatting with existing tests
- Add tests as unmarked `- [ ]` by default

What test would you like to add to the plan?
