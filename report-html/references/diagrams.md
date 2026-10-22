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
<script src="https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.min.js"></script>
<script>mermaid.initialize({ startOnLoad: true, theme: 'neutral', securityLevel: 'loose',
  flowchart: { htmlLabels: true, curve: 'basis' },
  themeVariables: { fontFamily: '"IBM Plex Sans KR", "Apple SD Gothic Neo", sans-serif', fontSize: '14px' } });</script>
```

`.diagram` scrolls sideways on narrow screens instead of widening the page. Number every figure and say in the caption what to look at.

## Syntax rules that prevent "Syntax error"

- Quote every label: `A["강사 모드<br/>src/chalk"]`. Quotes protect parentheses, slashes, colons, and Korean.
- Line breaks inside labels: `<br/>` (needs `htmlLabels: true`).
- Edge labels: `A -->|"요청 전달"| B`.
- Subgraph with a display name: `subgraph SERVICE["hypeproof-service (비공개)"]` … `end`. Node ids are ASCII without spaces.
- Decision diamond: `G1{"관문 1<br/>조건을 만족하나"}`; rounded terminal: `START(["시작"])`.
- Do not use `end` as a node id. Avoid `;` at line ends. Avoid `#` and unescaped `"` inside labels.
- In `sequenceDiagram`, participant aliases are ASCII: `participant C as hypeproof-chalk`. Message text is free text after `:`.
- The HTML file is the source: do not escape `<br/>` as `&lt;br/&gt;` inside `<pre class="mermaid">`.

## Patterns

**Where things end up (summary).** `flowchart LR`, 3–5 boxes, one per stage, each saying where the thing lives at that stage.

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

**Release / request sequence.** `sequenceDiagram` with `autonumber`; one participant per system or role; messages in the order they happen.

**Roadmap without dates.** `flowchart LR` of work packages with dependency arrows. Use `gantt` only when real dates exist.

**State of an item.** `stateDiagram-v2` for lifecycles (draft → review → merged → released).

## Simple visuals without Mermaid

- `.flow` — a straight row of 3–5 steps, no branching.
- `.compare` — two columns (as-is / to-be, goals / non-goals).
- `.kpis` — 2–4 headline numbers with labels.
- `.bars` — progress per phase (done vs. ready) with "n / m" on the right.
- `.tldr` — three cards for the summary.

## Check

After writing, open the page and confirm each `pre.mermaid` turned into an SVG and none shows "Syntax error in text". In a browser console:

```js
[...document.querySelectorAll('.mermaid')].map(e => !e.querySelector('svg') ? 'NOSVG' : /Syntax error in text|Parse error/.test(e.textContent) ? 'ERR' : 'ok')
```

Also confirm `document.documentElement.scrollWidth <= window.innerWidth` at ~400px width (no sideways scroll).
