# Worktree Parallel Skill

여러 독립적인 작업을 git worktree와 Claude Code subagent를 활용해 **자동으로 병렬 개발**하는 skill입니다.
사용자가 터미널을 별도로 열 필요 없이 Claude가 직접 N개의 subagent를 동시에 실행합니다.

---

## 설치

프로젝트 루트의 `worktree-parallel/` 디렉토리를 대상 프로젝트의 `.claude/skills/` 아래에 복사합니다.

```bash
cp -r worktree-parallel/ /path/to/your-project/.claude/skills/worktree-parallel/
```

또는 모든 프로젝트에서 사용하려면 개인 skills 폴더에 복사합니다.

```bash
cp -r worktree-parallel/ ~/.claude/skills/worktree-parallel/
```

---

## 사용 방법

Claude Code 세션에서 자연어로 병렬 작업을 요청하거나, 직접 호출합니다.

```
# 자연어 (자동 트리거)
auth 기능과 payment API를 병렬로 개발해줘

# 직접 호출
/worktree-parallel add-user-auth add-payment-api add-notification
```

---

## 동작 방식

```
Phase 1  Claude가 작업 수만큼 worktree와 브랜치를 생성
Phase 2  Claude가 단일 응답에서 N개의 Task 툴을 동시에 호출
         → 각 subagent가 할당된 worktree에서 독립적으로 구현 + 커밋
Phase 3  Claude가 브랜치를 하나씩 순차 머지 (충돌 발생 시 즉시 해결)
Phase 4  Worktree와 브랜치 정리 후 최종 결과 요약
```

---

## Skill 구조

```
worktree-parallel/
├── SKILL.md          # 메인 (frontmatter + 4단계 워크플로우 지침)
├── reference.md      # 상세 가이드 (환경파일 공유, 충돌 해결, 트러블슈팅)
└── scripts/
    ├── setup.sh      # Worktree 일괄 생성 자동화
    ├── merge.sh      # 순차 머지 자동화
    └── cleanup.sh    # 정리 자동화
```

---

## 알려진 한계 및 개선 사항

- **TDD 미지원**: 현재 각 worktree의 subagent는 TDD(Red→Green→Refactor) 방식으로 개발하지 않고 코드를 직접 작성합니다. TDD 커맨드(`/go`, `/red`, `/green` 등)와 연동하거나 subagent 프롬프트에 TDD 규칙을 주입하는 방식으로 개선이 필요합니다.
