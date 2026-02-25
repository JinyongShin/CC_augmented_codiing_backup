# Commit Commands (Tidy First)

## /tdd tidy

Propose and execute structural changes following Tidy First principles.

Structural changes (do first): renaming, extracting methods, moving code, reorganizing, reformatting.
Behavioral changes (do after): new features, bug fixes, modified functionality.
**Never mix these in one commit.**

1. Verify all tests pass: `pytest -v -s`
2. Identify structural improvements.
3. Propose one structural change at a time with rationale.
4. Apply, then run tests to confirm behavior is unchanged.
5. Suggest using `/tdd commit-structural` to commit.

---

## /tdd commit-structural

Commit structural changes only (Tidy First).

Pre-commit verification:
1. All tests pass (`pytest -v -s`)
2. No linter warnings
3. Changes are purely structural (rename, extract, move, reformat) - NO behavior changes
4. Tests prove behavior is unchanged

Commit message format:
```
structural: [Brief description]

- [What was changed structurally]
- [Why it improves structure]

All tests passing. No behavior changes.
```

If behavioral changes are detected, stop and suggest `/tdd commit-behavioral` instead.

---

## /tdd commit-behavioral

Commit behavioral changes only (new features, bug fixes).

Pre-commit verification:
1. All tests pass (`pytest -v -s`)
2. No linter warnings
3. Changes modify behavior (new features, fixes, new tests)
4. TDD cycle is complete (Red -> Green -> Refactor)
5. No structural changes mixed in (commit those first with `/tdd commit-structural`)

Commit message format using conventional commits:
```
feat|fix|test: [Brief description]

- [What behavior was added/changed]
- [What problem this solves]

TDD cycle complete. All tests passing.
```

If structural changes are mixed in, stop and suggest separating them.
