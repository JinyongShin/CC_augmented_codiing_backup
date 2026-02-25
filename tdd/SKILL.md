---
name: tdd
description: "Kent Beck's TDD and Tidy First workflow system. Use whenever the user wants to do TDD, write tests first, follow Red-Green-Refactor cycle, manage a test plan, or practice test-driven development. Triggers on: tdd, test driven, red green refactor, tidy first, write failing test, plan.md, test plan management. Sub-commands: plan-init, plan-add, plan-view, plan-reset, go, red, green, refactor, tidy, mark, next, status, test-run, commit-structural, commit-behavioral."
user-invokable: true
argument-hint: "<command> (plan-init|plan-view|plan-add|plan-reset|go|red|green|refactor|tidy|mark|next|status|test-run|commit-structural|commit-behavioral)"
---

# TDD Workflow System

A complete TDD workflow following Kent Beck's Test-Driven Development and Tidy First principles.

## Core Principles

- **TDD Cycle**: Red (failing test) -> Green (minimum code to pass) -> Refactor (improve structure)
- **Tidy First**: Separate structural changes from behavioral changes. Never mix them in one commit.
- **Minimum code**: Write the simplest failing test first, then the minimum code to pass it.
- **Test after every change**: Run `pytest -v -s` after each modification.

## Sub-Command Routing

When the user invokes `/tdd <command>`, read the corresponding reference file for detailed instructions.

| Command | Reference File | Description |
|---------|---------------|-------------|
| `plan-init` | `references/planning.md` | Create new plan.md |
| `plan-view` | `references/planning.md` | View test plan |
| `plan-add` | `references/planning.md` | Add test to plan |
| `plan-reset` | `references/planning.md` | Reset all marks |
| `go` | `references/cycle.md` | Full TDD cycle (Red->Green->Refactor) |
| `red` | `references/cycle.md` | Write failing test only |
| `green` | `references/cycle.md` | Minimum code to pass only |
| `refactor` | `references/cycle.md` | Improve structure only |
| `next` | `references/navigation.md` | Preview next test |
| `status` | `references/navigation.md` | Show progress and phase |
| `mark` | `references/navigation.md` | Mark test complete |
| `test-run` | `references/navigation.md` | Run all tests |
| `tidy` | `references/commits.md` | Propose structural changes |
| `commit-structural` | `references/commits.md` | Commit structural only |
| `commit-behavioral` | `references/commits.md` | Commit behavioral only |

Read ONLY the reference file matching the invoked command. Do not load other reference files.

## Available Commands Summary

When the user types `/tdd` without a sub-command, show this:

```
📋 TDD Workflow Commands

Planning:
  /tdd plan-init     Create a new test plan (plan.md)
  /tdd plan-view     View the full test plan
  /tdd plan-add      Add a new test to the plan
  /tdd plan-reset    Reset all test marks

TDD Cycle:
  /tdd go            Execute full TDD cycle for next test
  /tdd red           Write a failing test (RED phase)
  /tdd green         Write minimum code to pass (GREEN phase)
  /tdd refactor      Improve code structure (REFACTOR phase)

Navigation:
  /tdd next          Preview next test without executing
  /tdd status        Show TDD progress and current phase
  /tdd mark          Mark current test as complete
  /tdd test-run      Run all tests

Commits (Tidy First):
  /tdd tidy              Propose structural changes
  /tdd commit-structural Commit structural changes only
  /tdd commit-behavioral Commit behavioral changes only
```
