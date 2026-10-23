# Writing: practical Simplified Technical English (Korean and English)

ASD-STE100 is a controlled language for maintenance manuals: one reading, no second guess. These documents are not manuals, so aim for about 80% conformance. The goal is that a reader with thin context understands each sentence on the first pass, including someone reading in a second language or on a phone.

## Core rules

| Rule | Do | Not |
|---|---|---|
| One idea per sentence | "서버는 10/10 에 분리됐다. 그 뒤 예전 게이트웨이를 둘 이유가 없어졌다." | "서버가 10/10 에 분리됐고 그래서 예전 게이트웨이를 둘 이유가 없어졌으며…" |
| Short sentences | Procedural ≤ 20 words, descriptive ≤ 25. Paragraph ≤ 6 sentences | Long chains joined by -고, -며, -는데, "and", "which" |
| Active voice, named actor | "개발 팀이 고친다." "The release job uploads the file." | "수정이 이루어진다." "The file is uploaded." |
| Instructions are imperative | "Update branch 를 누른다." "Run `npm test`." | "누르시면 될 것 같습니다." "You may want to run…" |
| Condition before instruction | "CI 가 초록이면, 머지한다." | "머지한다, CI 가 초록이면." |
| One term per thing | Pick 검수 or 리뷰 and keep it; define at first use | Rotating synonyms for the same thing |
| Noun clusters ≤ 3 | "계획서 검사에서 나온 경고" | "강의 계획서 검사 결과 경고 문구" |
| No vague words | Numbers, file names, conditions | 적절히, 어느 정도, 등등, ~것 같다, "some", "various", "etc." |
| Tense matches fact | Present for what is true; past for what happened | Future for things already decided |
| Warnings first | `.flag.n` box before the step it governs, reason in one sentence | Warning after the step |
| Lists for steps and 3+ parallel items | One action per step, in the order the reader does them | Steps inside a paragraph |

## Uncertainty

Do not hedge with verbs. Put uncertainty in an explicit mark: "(추정)", "(미확인)", a `b-warn` badge, or a "measured / estimated" column. "지연은 하루 정도다(추정)." not "하루 정도 지연될 수도 있을 것 같다."

## Verbatim

Code, paths, commands, API names, error strings, UI labels, and quoted speech stay exactly as they are. STE rules never rewrite them.

## Tables count as prose

Table cells may be fragments, but still one idea per cell. Put the unit and scope in the header or caption, not repeated in every cell.

## Korean specifics

- Prefer plain declaratives (-다) in documents. Use polite endings only in messages to a person.
- Particles carry meaning; keep them. Compress by cutting filler, not grammar.
- Put a space between a Latin term and a Korean particle only when the team's style does; be consistent in one document.

## Self-check before delivery

1. Scan each section for sentences over the limit and split them.
2. Search for passive endings without an actor (되었다, 이루어졌다, 진행되었다) and name the actor.
3. Search for hedges (것 같, 수도 있, 적절, 어느 정도, 등등).
4. List the key terms and confirm each thing has one name.
