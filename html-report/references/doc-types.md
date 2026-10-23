# Document types and section blueprints

Pick the closest type. Sections marked (opt) are optional. Every type starts with a cover and a summary (thesis one-liner plus `.tldr` or KPIs), and a type with open choices ends with a decision section built per SKILL.md rule 6.

## Contents
1. Plan / design doc / migration plan
2. Decision memo
3. Status report
4. Investigation result
5. Periodic (weekly) report
6. Procedure / review guide
7. Proposal
8. Slides

---

## 1. Plan / design doc / migration plan

The strongest type. Experienced reviewers expect these sections (common to Google-style design docs, RFCs, and migration runbooks — reasoning and sources in `good-documents.md`):

| # | Section | What it answers | Usual visual |
|---|---|---|---|
| 00 | Summary | What changes, how, why now | thesis + `.tldr` + small "where things end up" Mermaid |
| 01 | Background | What exists today, what problem, why now. 2–3 short paragraphs, links for detail. Decisions already made (premises) as a table | table |
| 02 | Goals and non-goals | Measurable outcomes; things that could be goals but are explicitly out of scope | `.compare` |
| 03 | Current structure | Components, where code/data lives, coupling points | Mermaid flowchart with subgraphs + table with links |
| 04 | Target structure | Same picture after the change; who owns what | Mermaid + ownership table |
| 05 | Overall flow | All phases end to end, with gates and rollback paths | Mermaid flowchart TD with decision diamonds |
| 06 | Phase plan | Per phase: entry condition, work, exit criterion (gate), rollback | table; verification table |
| 07 | Release / rollout (opt) | How changes reach users | Mermaid sequenceDiagram |
| 08 | Settings / configuration (opt) | Exact values to apply, copied from the measured source | table |
| 09 | Decisions and alternatives considered | Overview table, then per-decision options with pros/cons and the recommendation | tables + `.ruling` |
| 10 | Roles | Who executes, approves, is consulted, is informed (RACI) | table |
| 11 | Risks and rollback | Risk, impact, mitigation; explicit rollback triggers and who calls them | table + list |
| 12 | After this (opt) | What work continues once the plan is done | Mermaid flowchart LR + table |
| 13 | Glossary | Every internal term | table |

Rules that matter for plans:
- Every phase has an **exit criterion a stranger could check** ("Dev app shows the same instructor flow; window capture attached"), not "done".
- Put the **irreversible or permission-needing steps** in the flow explicitly (first push, deletion, production change) and say who does them.
- If the user asks "how far can this go without me", answer from the RACI and the gates: list the touchpoints where only they can act.
- Mark estimates as estimates. Do not invent dates; give order and relative size when time is unknown.

## 2. Decision memo

| Section | Content |
|---|---|
| Summary | The decision needed, by when, and the recommendation |
| Context | Why now; what is blocked |
| Decisions | Overview table → one block per decision (repository/file, context, if undecided, options table with pros and cons, recommendation) |
| Consequences | What each choice changes downstream (table) |
| Next steps | What happens after each answer, and who acts |

## 3. Status report

| Section | Content |
|---|---|
| Summary | KPIs: done / in progress / blocked, each with scope and date |
| Progress | Table per work item: status badge, evidence link, next step |
| Changes since last report | What moved and why |
| Blocked / needs decision | Each with the owner and what unblocks it |
| Next | Commitments with dates |

## 4. Investigation result

| Section | Content |
|---|---|
| Summary | The answer in one sentence, then confidence |
| Question | Exactly what was asked, quoted |
| Method | What was examined and how (commands, sources, dates) |
| Findings | One finding per row: claim, evidence link, measured/estimated |
| Implications | What this changes |
| Open questions | What was not checked and why |

## 5. Periodic (weekly) report

Follow the team's own template when one exists — find it and copy its section order and field names. Common fields: commitments from last period vs. done (table with promise, deadline, result badge, evidence, reason for gap), progress against plan (`.bars`), role metrics, blocked, decisions needed, next-period commitments with done-criteria and dates, hours spent vs. promised.

- Write work in words, not internal codes.
- Leave a field empty or "—" when the user says so; do not fill it with guesses.
- Do not list other people's work as your own; mention it in one line as context if needed.
- Every evidence link must open for teammates (shared-document rules).

## 6. Procedure / review guide

For a person who will run steps by hand (QA review, release check, setup).

| Section | Content |
|---|---|
| Before you start | Prerequisites, versions, what to have open; cautions in `.flag.n` *before* the steps |
| Steps | `ol.steps`, one action per item, imperative; every command copied from the real script and verified |
| Check items | Table with ids (A-1, B-1…): what to do, what you should see, where the evidence is |
| Negative checks | What must *not* happen |
| Troubleshooting | Symptom → cause → fix table |
| Finish | How to close down and how to report results |

When a check must run on someone else's machine or environment, write each check so they can run it without asking: the exact command, what to look at, the pass criterion, what each result means, and a reply format ("C1: 정상/재현 + 출력 일부"). Do not write vague checks such as "배포 후 확인".

## 7. Proposal

Problem (with evidence) → proposed change → alternatives considered (table with pros/cons) → cost and effort → risks → ask (what decision, by when).

## 8. Slides

- HTML slides in one file; arrow keys and click to navigate; slide counter; print one slide per page.
- One idea per slide; a headline sentence as the slide title; at most ~5 bullets or one diagram/table.
- For an outside audience: definition → direction → what exists now. Leave out internal status, process, and codenames.
- Same palette, fonts, badges, and Mermaid setup as documents.
