# Obsidian Wiki Skills

Claude Code와 [Obsidian](https://obsidian.md)을 결합해, 대화·웹·파일에서 얻은 지식을 **영속적인 wiki vault**로 축적하고 다시 활용하기 위한 skill 모음입니다. 일종의 "LLM second brain"으로, 한 세션에서 조사한 내용을 다음 세션이 그대로 이어받습니다.

---

## 구성 철학

### 1. 3-레이어 아키텍처

```
.raw/      ← 원본 소스 (기사, 이미지, 스크랩). 가공 전 원형 보존.
wiki/      ← 가공된 지식 (sources / concepts / entities / questions / meta).
CLAUDE.md  ← vault 메타데이터 (모드, 컨벤션, 크로스 프로젝트 참조).
```

원본(`.raw/`)과 정제된 지식(`wiki/`)을 분리해, 언제든 원본으로 되돌아가 재가공할 수 있습니다.

### 2. Hot cache 우선

`wiki/hot.md`는 vault 전체를 ~500단어로 요약한 컨텍스트 캐시입니다. 질의 시 전체 vault를 읽지 않고 **hot → index → 개별 페이지** 순으로 점진적으로 읽어 토큰을 절약합니다.

### 3. 마스터 + 서브 스킬 (오케스트레이션)

`wiki` 하나가 진입점이자 오케스트레이터이고, 나머지는 단일 책임을 갖는 서브 스킬입니다. 사용자는 보통 `wiki`만 의식하면 되고, 세부 동작은 적절한 서브 스킬로 라우팅됩니다.

### 4. Vault-relative, 하드코딩 없음

모든 skill은 절대 경로를 쓰지 않고 vault 기준 상대 경로(`wiki/...`, `.raw/...`)만 사용합니다. 그래서 어떤 프로젝트에 복사하든 그대로 동작하며, vault 구조는 `wiki` skill의 scaffold 모드로 정해집니다.

---

## Skill 카탈로그

### 핵심 / 오케스트레이션

| Skill | 역할 |
|-------|------|
| `wiki` | **마스터.** vault 셋업·scaffold, hot cache 관리, 크로스 프로젝트 참조, 서브 스킬 라우팅. 6가지 scaffold 모드(Website / GitHub / Business / Research / Design / Personal) 제공. |

### 파이프라인 (입력 → 저장 → 질의 → 유지보수)

| Skill | 역할 |
|-------|------|
| `wiki-ingest` | 파일·URL·이미지를 `.raw/`에 받아들이고 source/entity/concept 페이지 생성. `.manifest.json` 해시로 델타 추적, 모순 플래그. |
| `save` | 현재 대화·답변·인사이트를 타입 추론해 적절한 wiki 폴더에 저장하고 index/log/hot 갱신. |
| `autoresearch` | 주제 하나로 웹 검색→수집→종합을 반복하는 자율 리서치 루프. 결과를 wiki에 구조화 저장. |
| `wiki-query` | hot→index→페이지 순으로 읽어 인용과 함께 답변. Quick / Standard / Deep 모드. |
| `wiki-lint` | 고아 페이지·죽은 링크·낡은 주장·frontmatter 누락 등 8종 헬스 체크. 리포트·대시보드·canvas 맵 생성. |

### 시각화 (Canvas)

| Skill | 역할 |
|-------|------|
| `canvas` | Obsidian `.canvas` 파일에 이미지·텍스트·PDF·노트를 zone 기반 자동 배치로 추가. |
| `json-canvas` | JSON Canvas 1.0 스펙 레퍼런스 (노드·엣지·그룹·색상·ID 규칙). |

### 레퍼런스 / 유틸 (대부분 의존성 없이 독립)

| Skill | 역할 |
|-------|------|
| `obsidian-markdown` | Obsidian Flavored Markdown 문법 레퍼런스 (wikilink, embed, callout, properties, math 등). **여러 skill의 공통 기반.** |
| `obsidian-bases` | `.base` 파일(Obsidian 네이티브 DB 뷰: 테이블/카드/리스트, 필터, 수식) 작성. |
| `obsidian-cli` | 실행 중인 Obsidian을 `obsidian` CLI로 제어 (노트 CRUD, 검색, 플러그인 개발/디버깅). |
| `defuddle` | 웹 페이지에서 광고·내비·푸터를 제거해 깨끗한 markdown으로. 토큰 40~60% 절약. `wiki-ingest`가 URL 처리 시 자동 호출. |

---

## 스킬별 트리거 레퍼런스

각 skill은 아래 문구가 대화에 나타나면 자동 발동됩니다. `/명령` 형태는 명시적으로 호출할 수도 있습니다.

| Skill | 대표 명령 | 트리거 문구 (예시) |
|-------|-----------|--------------------|
| `wiki` | `/wiki` | "set up wiki", "scaffold vault", "create knowledge base", "wiki setup", "obsidian vault", "knowledge base", "second brain setup", "persistent memory", "llm wiki" |
| `wiki-ingest` | — | "ingest", "ingest this url", "process this source", "add this to the wiki", "read and file this", "batch ingest", "ingest all of these" |
| `save` | `/save` | "save this", "save that answer", "file this", "save to wiki", "save this session", "file this conversation", "keep this", "save this analysis", "add this to the wiki" |
| `autoresearch` | `/autoresearch` | "autoresearch", "research [topic]", "deep dive into [topic]", "investigate [topic]", "find everything about [topic]", "research and file", "go research", "build a wiki on" |
| `wiki-query` | — | "what do you know about", "query:", "what is", "explain", "summarize", "find in wiki", "search the wiki", "based on the wiki", "wiki query quick", "wiki query deep" |
| `wiki-lint` | — | "lint", "health check", "clean up wiki", "check the wiki", "wiki maintenance", "find orphans", "wiki audit" |
| `canvas` | `/canvas` | "canvas new", "canvas add image/text/pdf/note", "canvas zone", "canvas list", "canvas from banana", "add to canvas", "put this on the canvas", "open canvas", "create canvas" |
| `json-canvas` | — | ".canvas 파일 작업, 비주얼 캔버스/마인드맵/플로우차트 생성 시, "Canvas files in Obsidian" 언급 시 (canvas의 스펙 레퍼런스) |
| `obsidian-markdown` | — | "write obsidian note", "obsidian syntax", "wikilink", "callout", "embed", "obsidian markdown", "wikilink format", "callout syntax", "obsidian formatting", "how to write obsidian markdown" |
| `obsidian-bases` | — | "create a base", "add a base file", "obsidian bases", "base view", "filter notes", "formula", "database view", "dynamic table", "task tracker base", "reading list base" |
| `obsidian-cli` | — | vault를 CLI로 조작/검색/관리하거나 Obsidian 플러그인·테마를 개발·디버깅할 때 (Obsidian 실행 중 필요) |
| `defuddle` | — | "defuddle", "clean this page", "strip this url", "fetch and clean", "clean web content before ingesting", "strip ads", "remove clutter", "readable markdown from URL" |

> `json-canvas`, `obsidian-markdown`, `obsidian-bases`, `obsidian-cli`는 주로 다른 skill이 참조하거나 문맥에 따라 자동 발동하는 **레퍼런스 성격**이라 별도 명령이 없습니다.

---

## 의존 관계

```
                        wiki (master)
        ┌──────────┬──────────┼──────────┬──────────────┐
   wiki-ingest  wiki-query  wiki-lint  autoresearch   canvas
        │           │          │           │             │
    defuddle      save     json-canvas    save      json-canvas
        │                                   │
  obsidian-markdown  ◀── 공통 문법 기반 (autoresearch, wiki-ingest, save, canvas)

독립 레퍼런스: obsidian-cli, obsidian-bases
```

- **공통 기반:** `obsidian-markdown`은 페이지를 생성하는 거의 모든 skill이 문법 참조로 사용합니다.
- **권장 최소 설치:** `wiki` + `obsidian-markdown` + `wiki-ingest` + `wiki-query` + `save`.
- 12개를 모두 설치해도 무방하며, 서로 자연스럽게 연동됩니다.

---

## 사용법

### 설치

```bash
# 프로젝트 루트에서 12개 skill을 한 번에 복사
mkdir -p .claude/skills
cp -r obsidian-wiki/* .claude/skills/
```

### 첫 셋업 (vault scaffold)

```
/wiki set up wiki          # vault 구조 생성 (모드 선택)
```

한 문장으로 목적을 설명하면 그에 맞는 모드로 `.raw/`, `wiki/`, `CLAUDE.md`를 scaffold 합니다.

### 일상 워크플로우

```
1. 수집:  ingest this url https://...        → wiki-ingest (+ defuddle)
          save this                           → save
2. 조사:  research "<주제>"                    → autoresearch
3. 질의:  what do you know about <주제>?       → wiki-query
4. 유지:  lint                                 → wiki-lint
5. 시각화: /canvas add note <page>             → canvas
```

### 외부 의존성 (선택)

| 도구 | 용도 | 필요 skill |
|------|------|-----------|
| `npm i -g defuddle-cli` | 웹 페이지 정제 | `defuddle` (없으면 WebFetch로 폴백) |
| Obsidian 1.12+ + `obsidian` CLI | vault 직접 제어 | `obsidian-cli` |
| Dataview / Bases 플러그인 | 대시보드 | `wiki-lint`, `obsidian-bases` (없어도 동작) |
| `md5sum` / `sha256sum` | 델타 추적 | `wiki-ingest` |

---

## 출처

이 skill 모음은 `hypeproof_kids_edu` 프로젝트의 `.claude/skills/`에서 가져와 이 repo의 배포 구조에 맞게 정리한 것입니다.
