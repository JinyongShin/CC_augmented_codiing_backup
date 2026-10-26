# Diagrams

Diagrams are what make these documents readable at a glance. Use one wherever there are arrows, phases, or change over time. A good diagram shows the real mechanism with real names; a decorative one wastes the reader's attention.

## Setup (already in the template)

```html
<figure class="diagram">
  <pre class="mermaid">
flowchart LR
  A["Label"] --> B["Label"]
  </pre>
  <figcaption>그림 1. What the reader should notice</figcaption>
</figure>
...
<script src="https://cdn.jsdelivr.net/npm/mermaid@11.17.2/dist/mermaid.min.js"></script>
<script>mermaid.initialize({ startOnLoad: true, theme: 'neutral', securityLevel: 'loose',
  flowchart: { htmlLabels: true, curve: 'basis' },
  themeVariables: { fontFamily: '"IBM Plex Sans KR", "Apple SD Gothic Neo", sans-serif', fontSize: '14px',
    commitLabelFontSize: '13px', tagLabelFontSize: '13px' } });</script>
```

`.diagram` scrolls sideways on narrow screens instead of widening the page. Number every figure and say in the caption what to look at.

## Syntax rules that prevent "Syntax error"

- Quote every label: `A["관리자 화면<br/>src/admin"]`. Quotes protect parentheses, slashes, colons, and Korean.
- Line breaks inside labels: `<br/>` (needs `htmlLabels: true`).
- Edge labels: `A -->|"요청 전달"| B`.
- Subgraph with a display name: `subgraph SERVICE["order-service (비공개)"]` … `end`. Node ids are ASCII without spaces.
- Decision diamond: `G1{"관문 1<br/>조건을 만족하나"}`; rounded terminal: `START(["시작"])`.
- Do not use `end` as a node id. Avoid `;` at line ends. Avoid `#` and unescaped `"` inside labels.
- In `sequenceDiagram`, participant aliases are ASCII: `participant C as web-app`. Message text is free text after `:`.
- The HTML file is the source: do not escape `<br/>` as `&lt;br/&gt;` inside `<pre class="mermaid">`.

## Layout rules that keep labels readable

- A `flowchart LR` row holds **5 nodes or fewer**. Mermaid scales the whole diagram down to the column width (about 775px inside the figure). Measured with the template: 5 nodes keep labels at 12.4px; 7 nodes drop them to 8.8px.
- Past 5 nodes, switch to `flowchart TD`, split into two figures, group nodes into `subgraph`s, or use `.flow` when there is no branching.
- Keep node labels to two short lines. Long labels widen every box in the row.
- `verify.sh` prints the smallest on-screen label size per figure. Fix every figure it marks with `!!` (below 10px); look at the screenshot for `!` (10–11px).

## Patterns

**Where things end up (summary).** `flowchart LR`, 3–5 boxes (never more than 5), one per stage, each saying where the thing lives at that stage.

**Current / target structure.** `flowchart TB` with one `subgraph` per repository or system, components inside, labelled edges for calls (`-->|"HTTP"|`), bidirectional coupling as `<-->`. Draw current and target with the same layout so the reader can compare.

**Overall flow with gates.** `flowchart TD`. One `subgraph` per phase listing its steps; after each phase a diamond gate; the "no" edge goes back into the phase or to a rollback node; the "yes" edge goes to the next phase. End with what happens after (rounded terminal). This is the diagram reviewers look at first in a plan.

```
flowchart TD
  START(["시작"]) --> P0
  subgraph P0["0단계 준비"]
    D["결정 확정"] --> R["저장소 생성"]
  end
  P0 --> G0{"관문 0<br/>PR 도구가 동작하나"}
  G0 -->|"아니오"| P0
  G0 -->|"예"| P1
  subgraph P1["1단계 분리"]
    M["코드 이동"] --> X["원본 삭제"]
  end
  P1 --> G1{"관문 1<br/>동작이 같나"}
  G1 -->|"아니오"| RB["되돌림"] --> P1
  G1 -->|"예"| DONE(["완료"])
```

**Branch and merge order.** `gitGraph` for PR split plans and release branches. Keep branch names short and without spaces; write the real names in the text. Commit ids may be Korean but must be unique. Use `%%{init: {'gitGraph': {'mainBranchName': 'develop'}}}%%` only when the main branch is not `main`.

```
gitGraph
  commit id: "기준"
  branch fix-a
  commit id: "버그 수정"
  checkout main
  merge fix-a
```

**Release / request sequence.** `sequenceDiagram` with `autonumber`; one participant per system or role; messages in the order they happen.

**Roadmap without dates.** `flowchart LR` of work packages with dependency arrows. Use `gantt` only when real dates exist.

**State of an item.** `stateDiagram-v2` for lifecycles (draft → review → merged → released).

## SVG figures (core mechanism)

Use a hand-drawn inline SVG for the one to three figures that carry the document's core mechanism, when the `artifact-diagramming` skill is available in the session. Load that skill first and follow its guidance on what to draw: the real mechanism, labeled arrows, one claim per figure, the difference between options. Use Mermaid for everything else (sequences, gantt, gitGraph, state, simple flows), and for these figures too when the skill is not available.

Rules from this skill override that skill's:

- **Light theme only.** No `prefers-color-scheme`, no dark-ground theming. Do not write literal `fill`/`stroke` colors; use the template classes below, which read the color tokens.
- **Same width as the column.** `viewBox` width 760 or less, so 12px labels stay at 12px. Wider viewBoxes shrink every label (800 wide drops 12px to about 11.6px). On phones the figure keeps `min-width: 560px` and scrolls sideways inside `.svg-scroll`.
- **Self-contained SVG.** No `<script>`, `<style>`, or `<foreignObject>` inside the `<svg>`. Give the `<svg>` `role="img"` and an `aria-label` that states the same claim as the caption.
- **Shared arrowheads.** The template has one hidden `<svg>` right after `<body>` with the markers `#mk`, `#mk-on`, `#mk-warn`, `#mk-clash`. Edges pick them through CSS, so do not add `<marker>` or `marker-end` to a figure. Keep that hidden block when you delete sample components.
- **Not published.** The figure lives in the HTML file like any other block (rule 1).

### Classes

| Part | Class | Use |
|---|---|---|
| Box | `<g class="nd">` + `<rect>` (or `<polygon>` for a diamond) | A component, stage, or state |
| Box title / detail | `<text class="tt">` / `<text class="sm">` | 14px name / 12px path, count, or note |
| Box encoding | `.nd.k-acc` / `.k-warn` / `.k-ok` | Colored border for an actor type (for example LLM / human / rule). Say what each color means in the caption |
| Edge | `<path class="ed">` | Arrow. Add `.dash`, `.warn`, `.clash`, or `.noarrow` |
| Edge label | `<text class="lb">` | What moves on the edge: `요청`, `결과 저장` |
| Text color | `.acc` / `.warnt` / `.clasht` | Accent / caution / conflict text |
| Group | `<rect class="zone">` / `.zone.acc` | Background area behind boxes of one system |

### Interaction (`figure.ix`)

Interaction is worth adding when a part needs three to five facts that would clutter the drawing, or when the picture builds up step by step. Otherwise leave the figure static (drop `ix`, the buttons, and the panel).

Every interactive figure has the same frame: a hint line, a row of buttons, the SVG, a panel, and the caption.

```html
<figure class="diagram fig-svg ix" data-default="in" data-dim>
  <div class="fig-hint">경로 버튼이나 상자를 누르세요</div>
  <div class="fig-tabs" role="toolbar" aria-label="그림 조작">
    <button type="button" data-k="in">요청 접수</button>
    <button type="button" data-k="work">처리</button>
  </div>
  <div class="svg-scroll"><svg viewBox="0 0 760 120" role="img" aria-label="…">
    <path class="ed" d="M140,58 H226" data-on="in"/>
    <g class="nd" data-k="in" data-on="in" tabindex="0" role="button" aria-label="웹 앱">
      <rect x="20" y="30" width="120" height="56" rx="5"/>
      <text class="tt" x="80" y="55" text-anchor="middle">웹 앱</text>
      <text class="sm" x="80" y="72" text-anchor="middle">web/</text>
    </g>
    …
  </svg></div>
  <div class="fig-panel" aria-live="polite">
    <div data-panel="in" hidden><h4>요청 접수</h4><dl><dt>하는 일</dt><dd>…</dd></dl></div>
    <div data-panel="work" hidden>…</div>
  </div>
  <figcaption>그림 3. … 경로를 고르면 그 경로만 강조된다</figcaption>
</figure>
```

The template script handles every `figure.ix`; do not write per-figure scripts.

- **Keys.** A button or a box with `data-k="key"` selects that key. Every key, and `data-default`, needs a `<div data-panel="key" hidden>` in `.fig-panel`. Clickable boxes get `tabindex="0" role="button" aria-label` so a keyboard can reach them (Enter and Space select).
- **Select mode.** Elements whose `data-on` lists the key (space-separated) get `.on`. With `data-dim` on the figure, the other `data-on` elements fade. Use it to show one path or one part at a time.
- **Step mode.** Buttons are steps in order; their position is the step number (0 = first button). `data-from="n"` shows an element from step n, `data-new="n"` marks it new at step n, `data-prop="n"` marks it as a proposal (red dashed) from step n on. The panel of each step can hold a table of what has accumulated so far; mark the rows added in that step with `<tr class="fresh">`.
- **Panel content.** A `<dl>` of three to five rows (하는 일, 입력, 출력, 예, 주의) or a short paragraph plus a table. Write the panels in the figure, not in a script, so they are edited next to the drawing.
- **Default.** Set `data-default` so the panel is never empty on load.
- **Print and no-JS.** Printing hides the buttons and shows every panel in order. Still put each fact the reader must know in the caption or the prose; the panels add detail.
- **One figure, one script path.** If a figure seems to need custom behavior (text that changes, counts computed in script), split it into two figures instead.

When the user asks for a revision, redraw only the parts that change and keep the grid (same box size, same gaps), so the figure stays comparable across versions.

## Simple visuals without Mermaid

- `.flow` — a straight row of 3–5 steps, no branching.
- `.compare` — two columns (as-is / to-be, goals / non-goals).
- `.kpis` — 2–4 headline numbers with labels.
- `.bars` — progress per phase (done vs. ready) with "n / m" on the right.
- `.tldr` — three cards for the summary.

## Check

After writing, run `scripts/verify.sh` (see SKILL.md workflow step 6). It counts rendered diagrams and SVG figures, flags syntax errors, prints the smallest label size per figure, saves section screenshots, and checks 400px overflow. `check_report.py` warns on a `flowchart LR` with more than 5 nodes, checks each `fig-svg` for `viewBox`, `role`, `aria-label`, and literal colors, and checks that every key of an interactive figure has a panel. Without Chrome, open the page and confirm each `pre.mermaid` turned into an SVG and none shows "Syntax error in text". In a browser console:

```js
[...document.querySelectorAll('.mermaid')].map(e => !e.querySelector('svg') ? 'NOSVG' : /Syntax error in text|Parse error/.test(e.textContent) ? 'ERR' : 'ok')
```

Also confirm `document.documentElement.scrollWidth <= window.innerWidth` at ~400px width (no sideways scroll).
