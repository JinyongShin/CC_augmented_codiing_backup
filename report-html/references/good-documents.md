# What good documents contain (research notes)

Research done once (2026-10) so each run does not repeat it. Sources: Google-style design docs, engineering RFC practice, migration/cutover runbooks, monorepo-split guides. `doc-types.md` turns these findings into section blueprints; read this file when you need the reasoning behind a section or want to check a draft against what experienced reviewers expect.

## Design docs and RFCs

Google's design-doc practice and most company RFC templates converge on the same skeleton:

| Section | What reviewers look for |
|---|---|
| Context and scope | What exists today, what problem, why now. Two or three paragraphs; link background instead of restating it |
| Goals and non-goals | Goals: specific, measurable outcomes, one bullet each. Non-goals: things that *could* reasonably be goals but are explicitly out of scope — this bounds the review |
| The design | The target system, usually with a system-context diagram; APIs and data storage when they change |
| Alternatives considered | The options rejected and why. Reviewers trust a doc more when it shows the road not taken |
| Cross-cutting concerns | Security, privacy, deployment, observability, testing strategy |

Lessons: short beats complete; diagrams beat prose for structure; a doc that only describes the chosen option reads as a sales pitch.

## Migration and cutover plans

Migration runbooks (cloud, data, repository) add what design docs often lack:

- **Inventory and dependency map** of what moves and what it is coupled to.
- **Waves / phases** ordered from least to most critical, each with **entry and exit criteria**.
- **Cutover and rollback**: before cutover, define the conditions that trigger a rollback, who has authority to call it, and how long rollback takes. An untested rollback plan is a wish, not a plan.
- **Ownership** per workload and environment (RACI). Plans fail when cutover, rollback, and ownership are undefined.
- **Test and validation plan**: what proves each phase worked.

## Splitting a repository

- `git filter-repo --path <dir>` keeps only the history of the chosen paths and is the current recommended tool (`filter-branch` is deprecated). Clone fresh (`--no-local`) before filtering.
- Pushing filtered history into a new repository is a one-time direct push; a squash-only PR would collapse the history. Plan it as an explicit, approved exception.
- Scan the filtered history for secrets before the push.
- Leave the old location working until the new one passes its gates; delete the old copy last, in its own change, so rollback is one revert.

## Status and executive reports

- First screen: the answer and 2–4 headline numbers, each with its base and period.
- Progress against commitment, not activity lists.
- Risks as a table with impact and mitigation; decisions needed with a deadline.

## Sources

- The Pragmatic Engineer — "Companies Using RFCs or Design Docs and Examples of These": https://blog.pragmaticengineer.com/rfcs-and-design-docs/
- "Mastering Google Design Docs" (Google design-doc structure): https://medium.com/@alessandro.traversi/mastering-google-design-docs-a-comprehensive-guide-with-readme-md-template-a2706b57f64d
- KORE1 — "Data Migration Plan: What to Demand Before Cutover": https://www.kore1.com/data-migration-plan-engineering-leaders/
- Pilotcore — AWS migration project plan example: https://pilotcore.io/blog/complete-guide-planning-aws-migration
- "How to Move Specific Folders to a New Git Repository (with Full History)": https://medium.com/@vivazmo/how-to-move-specific-folders-to-a-new-git-repository-with-full-history-5a3f2f65078d
- Git Tower — git filter-repo FAQ: https://www.git-tower.com/learn/git/faq/git-filter-repo
