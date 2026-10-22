---
name: report-html
description: Build a polished, self-contained HTML document that a person will read, review, present, or share — status reports, project/migration/implementation plans, design docs, decision memos, investigation results, weekly or periodic reports, review/procedure guides, proposals, and HTML slide decks — with Mermaid diagrams, tables, and plain, unambiguous prose. Use this whenever the user asks for a 보고서, 보고, 계획서, 기획서, 제안서, 정리해서 보여줘, 현황, 위클리, 결정 문서, 검수 가이드, 발표 자료, 슬라이드, "html로", a report/plan/write-up/one-pager/RFC/design doc, or any answer that is a document someone will read rather than a short chat reply — even if the word HTML is never used. Not for app UIs, dashboards with live data, or editing an existing website.
---

# report-html

Produce a single HTML file that reads like a well-edited technical document: one reading column, a left navigation rail, clear type hierarchy, diagrams that show the real mechanism, tables for anything comparable, and short, literal sentences. The reader may have no context, may be on a phone, and may be presenting the page to a room.

These rules came from one owner's repeated corrections over months of real reports. Each rule states its reason. When a case is not covered, follow the reason, not the letter.

## Workflow

1. **Classify the document.** Pick a type from `references/doc-types.md` (status report, plan/design doc, decision memo, investigation, periodic report, procedure guide, slides). Each type has a section blueprint. Decide the audience: *owner only* or *shared* (team, other teams, external). Shared documents follow the sharing rules below.
2. **Check the blueprint against what reviewers expect.** For a plan, proposal, or design, read `references/good-documents.md` (research already done: design docs, RFCs, migration runbooks, repository splits). If the team has its own template or a prior document of the same type, follow that structure first. Do not repeat general web research for document structure; research only the subject matter when facts are missing.
3. **Gather facts, and verify them.** Read the source material yourself: repository files, issues, PRs, logs, settings via API. Record for each claim whether you measured it or inferred it. Check that every path, command, and link you will cite exists. A wrong link or command in a shared document costs more trust than it saves time.
4. **Propose the structure first** for a new document: section titles plus one sentence per section that states its core message. Wait for approval. Skip this only for a routine update of a known shape, or when the user says to write directly. This step exists because rewriting a finished document is far more expensive than moving a heading.
5. **Write the file.** Copy `assets/template.html`, fill the cover, rail, and sections, delete unused sample components. Use diagrams (`references/diagrams.md`) and tables generously — they are what makes the page readable at a glance. Write prose to `references/writing.md`.
6. **Check before delivery.** Run `python3 scripts/check_report.py <file> [--shared]` and fix what it reports. Then open the page in a browser if one is available and confirm every Mermaid diagram rendered (no "Syntax error" text) and the page does not scroll sideways at phone width.
7. **Deliver.** Give the absolute path and a short summary of what the document says and what the reader must decide. Follow the owner conventions at the end of this file for delivery channel and notifications.
8. **Revise in place.** Keep the same file path across revisions so links stay valid. Mark the revision on the cover (2판, v3). Keep the previous version as a scratch copy if the change is large.

## Output rules

### 1. One file, light theme, works offline except for fonts and Mermaid

A single `.html` file with inline CSS. External resources: Google Fonts and the Mermaid script from `cdn.jsdelivr.net` only. Light theme only — no `prefers-color-scheme`, no dark palette, no theme toggle. The owner asked to remove dark mode five times; printed and projected pages also read better light.

Do not publish to a hosting service (Artifact, gist, pastebin) unless the user asks after review. The user edits and discusses the file before it goes anywhere.

### 2. One reading width

Every readable block — paragraphs, tables, boxes, diagrams — uses the same width (`--measure`, class `.col`). Do not put `<br>` inside paragraphs; let text wrap. Uneven widths and forced breaks make a page look broken. Use `word-break: keep-all` on headings and table keys only; on body text in narrow cells it leaves one word per line.

### 3. Clear type hierarchy, short titles

Title, section heading, subheading, lede, body, box text, and table text each look different (the template scale: 35 / 26 / 19 / 19.5 / 16.5 / 15.5 / 14.5 px). Do not invent sizes per section.

Titles are names of two to five words. The explanation goes in the lede under the title. "Chalk 분리 계획", not "Chalk 를 studio 에서 분리하고 별도 배포하기 위한 계획과 결정 사항 정리".

Section headings (h2, h3) are **labels, not sentences**. A label names what the section is about so the reader can find it in the rail: "요약", "한 줄 결론", "지금 구조", "결정 사항", "위험과 되돌리기". Do not write the section's conclusion as its heading — "성과는 좋고, 결정 1건이 남았다", "URL 을 지키며 옮긴다" read as slogans and make the rail hard to scan. Put the claim in the `.thesis` or `.lede` right under the heading instead. "한 줄 결론" is a good default for the summary heading, but any short noun phrase that names the section works.

### 4. Readable with zero context

Someone joining the team today must understand the page without asking. Explain every internal term at first use or replace it with plain words: codenames, milestone codes (M2, E3-3), ticket numbers without a description, section references like "§7", session or bot names. Write what a milestone *is* ("운영 문서 만들기 단계"), not its code. Never write "see the other doc" in place of an explanation — put the explanation here and link the other doc as evidence. Add a glossary section when more than five terms need defining.

### 5. Show, do not only tell

Draw systems, flows, phases, and change. Use Mermaid (`references/diagrams.md`) for anything with arrows: architecture, data flow, phase flow with gates, sequences, timelines. Use the HTML components (`.flow`, `.compare`, `.kpis`, `.bars`, `.tldr`) for simple step rows, as-is/to-be, headline numbers, and progress. A diagram must show the real mechanism — real component names, real direction of calls. Give each diagram a numbered caption that says what to notice.

Use a table whenever three or more items share attributes. Comparisons, options, phases, roles, risks, settings, and glossaries are tables, not paragraphs.

### 6. Decisions stand alone

When a choice is open, do not stop to ask in chat — write it into the document so the reader decides while reading:

- Start the decision section with an overview table: id, topic, recommendation, what it blocks.
- For each decision: what it changes (repository/file, or "none"), why it must be decided now, what stays blocked if undecided, an options table with **pros and cons for every option**, and the recommendation with its reason (`.ruling` box).
- Write each decision so it can be read alone, without scrolling back. The reader jumps straight to it.

### 7. Separate fact from guess, and scope every count

Mark what was measured and what was inferred: badges (`b-ok`, `b-warn`, `b-plan`, `b-none`) or the words "실측 / 추정" (measured / estimated). Every number states its set and date: "35개 하위 이슈 중 21개 (10/12 기준)", not "21 done". Unscoped counts were the most frequent correction.

### 8. Built to present

The page is often projected and walked through by scrolling. Keep the left rail with scroll tracking. Start with a summary block (`.thesis` one-liner plus `.tldr` or KPIs) so the first screen answers "what is this and what do you need from me".

### 9. Plain, literal prose

Follow `references/writing.md`: a practical adaptation of ASD-STE100 Simplified Technical English for Korean and English. Aim for about 80% conformance — short sentences, one idea each, active voice with a named actor, imperative instructions, one term per thing, no hedging words. Exact compliance matters less than a reader understanding each sentence on the first pass. Code, paths, commands, error strings, and quotes stay verbatim.

## Shared documents

A document is *shared* when anyone other than the owner will read it. Then:

- **No local references.** No local file paths (`/Users/…`, `~/…`, `C:\…`, temp dirs, private worklog folders), no local-only file names, no machine names. Cite only what others can open: repository files as links to the hosting site (pin to a branch or commit), issues, PRs, search URLs. Note when a linked repository is private.
- **No internal agent or session names.** Describe people and agents by role ("제품 리드", "개발 팀", "조직 관리자"). Use a person's name only when the audience knows them.
- **Link evidence instead of pasting it.** Every claim about code or settings links to the file or page that shows it.
- **No secrets.** Never include tokens, keys, internal credentials, customer data, or personal data — not even redacted examples that reveal format.
- Run `check_report.py --shared`, and add `--forbid` patterns for names that must not appear.

## Formats

**Document (default).** Rail plus one reading column. Use for everything except slides. Start from `assets/template.html`.

**Slides.** When the user asks for slides, a deck, 발표, 덱, or "ppt 형태로 html": produce HTML slides, not `.pptx`. Same palette and fonts, one idea per slide, arrow-key navigation, Mermaid allowed. For an outside audience, leave out internal status and process; order is definition, direction, then what exists now. See `references/doc-types.md` → Slides.

## Template components (`assets/template.html`)

| Class | Use |
|---|---|
| `.cover` + `.cover-meta` | Title, lede, and a meta list: date, author/role, audience, status, evidence basis |
| `.thesis` | The one-sentence answer, dark block, once near the top |
| `.tldr` | Three short cards: what / how / why now (or ask / impact / deadline) |
| `.kpis` · `.bars` | Headline numbers · progress per phase |
| `.sec-head` + `.eyebrow` + `.lede` | Section header with number and one-sentence core |
| `figure.diagram` > `pre.mermaid` + `figcaption` | A Mermaid diagram with a numbered caption |
| `table` in `.t-wrap` | Tables; `.t-key` first column, `.t-num` numbers, `caption` states scope |
| `.compare` | Two columns: as-is / to-be, goals / non-goals |
| `.flow` | Simple horizontal step row without branching |
| `.ruling` + `.alt` | The document's recommendation, with the other options |
| `.flag` / `.flag.n` | Conflict or gap (red) / caution or limit (amber); put a caution *before* the step it applies to |
| `.quote` | Someone else's words, with source |
| `.badge` `.b-ok/.b-warn/.b-plan/.b-none` | Done / partial / planned / missing |
| `ul.plain`, `ol.steps` | Lists; `steps` for ordered procedures, one action per item |

Use each box for its stated role only. When every paragraph sits in a box, nothing stands out.

## Owner conventions (this install)

These are the defaults of the person this skill was built for. Another user can edit or delete this section; the rest of the skill does not depend on it.

- Reply in Korean; write documents in Korean unless asked otherwise.
- Save location: the project's private notes folder outside any git working tree (for HypeProof: `<workspace>/_worklog/…`; Chalk work under `_worklog/chalk/po/reports/`, then one line in `_worklog/chalk/index.md`). Never save inside a repository working tree; always use absolute paths.
- After writing or revising a document: send the file with `SendUserFile`, and send a `PushNotification` that leads with what the reader must act on (e.g. "계획서 2판 — 결정 12건 검토 필요"). Every revision, not only the first.
- Team-facing reports (weekly reports, PR comments, plans shared with the team) are *shared documents* — apply the sharing rules.
