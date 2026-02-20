# Augmented Coding Rules for Claude Code

Kent Beck의 Test-Driven Development와 Tidy First 원칙을 Claude Code에 적용하는 구성 모음입니다.

## 구성 요소

| 디렉토리 | 설치 경로 | 역할 |
|----------|-----------|------|
| `rules/` | `.claude/rules/` | TDD + uv 정책 자동 적용 (필수) |
| `tdd_commands/` | `.claude/commands/` | 단계별 수동 제어 커맨드 (필수) |
| `worktree-parallel/` | `.claude/skills/worktree-parallel/` | 병렬 개발 skill (선택) |

---

## 목차

1. [시작하기](#시작하기)
2. [핵심 워크플로우](#핵심-워크플로우)
3. [명령어 레퍼런스](#명령어-레퍼런스)
4. [실전 예제](#실전-예제)
5. [베스트 프랙티스](#베스트-프랙티스)
6. [트러블슈팅](#트러블슈팅)
7. [치트 시트](#치트-시트)

---

## 시작하기

### 설치

```bash
# 1. TDD + uv 정책 적용 (필수)
#    rules/TDD.md → Claude Code가 자동으로 TDD 방식으로 개발
#    rules/uv.md  → Python 프로젝트에서 자동으로 uv 패키지 매니저 사용
mkdir -p .claude/rules
cp rules/* .claude/rules/

# 2. 단계별 제어 커맨드 설치 (필수)
mkdir -p .claude/commands
cp -r tdd_commands/*.md .claude/commands/

# 3. 병렬 개발 skill 설치 (선택)
#    여러 독립적인 작업을 동시에 개발할 때 사용
mkdir -p .claude/skills
cp -r worktree-parallel/ .claude/skills/worktree-parallel/
```

### plan.md 작성

프로젝트 루트에 `plan.md`를 작성합니다. `plan.md.example`을 참고하세요.

```markdown
## Tests

- [ ] Test 1: User should be able to create account with valid email
- [ ] Test 2: User registration should reject invalid email formats
- [ ] Test 3: User password should be hashed before storage
```

### 첫 번째 TDD 사이클

rules 설치 후 Claude Code는 자동으로 TDD 방식으로 개발합니다.
커맨드는 그 위에서 단계별 진행을 직접 제어하고 싶을 때 사용합니다.

```bash
/go   # 다음 테스트의 전체 TDD 사이클(Red → Green → Refactor) 자동 실행
```

---

## 핵심 워크플로우

> **rules가 TDD를 기본 적용합니다.** 커맨드는 단계별 진행을 직접 제어하고 싶을 때 사용합니다.

### 기본 TDD 사이클

```
1. /go           → 다음 테스트 자동 실행 (Red → Green → Refactor)
2. /mark         → 테스트 완료 표시
3. 반복
```

### 수동 제어 워크플로우

더 세밀한 제어가 필요한 경우:

```
1. /next         → 다음 테스트 미리보기
2. /red          → 실패하는 테스트 작성
3. /test-run     → 테스트 실행 (실패 확인)
4. /green        → 최소 코드로 테스트 통과
5. /test-run     → 테스트 실행 (통과 확인)
6. /refactor     → 코드 개선 (선택)
7. /test-run     → 테스트 실행 (여전히 통과하는지 확인)
8. /mark         → 완료 표시
```

### Tidy First 워크플로우

구조적 변경과 행동적 변경을 분리:

```
1. /tidy                    → 구조적 개선 제안 및 적용
2. /test-run                → 행동 변경 없음 확인
3. /commit-structural       → 구조적 변경 커밋
4. /go                      → 새 기능 구현 (행동 변경)
5. /commit-behavioral       → 행동 변경 커밋
```

---

## 명령어 레퍼런스

전체 명령어 상세 설명은 **[docs/commands.md](docs/commands.md)** 를 참조하세요.

| 명령어 | 용도 |
|--------|------|
| `/go` | 자동 TDD 사이클 |
| `/red` | RED 단계 - 실패 테스트 작성 |
| `/green` | GREEN 단계 - 최소 구현 |
| `/refactor` | REFACTOR 단계 - 코드 개선 |
| `/test-run` | 테스트 실행 |
| `/mark` | 테스트 완료 표시 |
| `/next` | 다음 테스트 미리보기 |
| `/status` | 현재 TDD 상태 확인 |
| `/tidy` | 구조적 개선 (Tidy First) |
| `/commit-structural` | 구조적 변경 커밋 |
| `/commit-behavioral` | 행동 변경 커밋 |
| `/plan-view` | 전체 계획 보기 |
| `/plan-add` | 새 테스트 추가 |
| `/plan-reset` | 모든 마크 초기화 |

---

## 실전 예제

상세 예제는 **[docs/examples.md](docs/examples.md)** 를 참조하세요.

- **예제 1**: 간단한 기능 추가 (`/go` → `/mark` 반복)
- **예제 2**: 수동 제어로 세밀하게 작업
- **예제 3**: Tidy First 워크플로우

---

## 베스트 프랙티스

### 1. TDD 사이클 준수

✅ **좋은 예**:
```
/red → /test-run → /green → /test-run → /refactor → /test-run → /mark
```

❌ **나쁜 예**:
```
테스트와 구현을 동시에 작성 (TDD 아님!)
```

### 2. 작은 단계로 진행

✅ 한 번에 하나의 테스트, 한 번에 하나의 리팩토링, 작고 빈번한 커밋

❌ 여러 테스트를 한 번에 작성, 큰 리팩토링을 한 번에 수행

### 3. 테스트를 자주 실행

테스트 작성 후, 코드 작성 후, 리팩토링 후 — 매번 `/test-run`

### 4. 구조적/행동적 변경 분리

✅ `/tidy` → `/commit-structural` → `/go` → `/commit-behavioral`

❌ 구조 변경과 기능 추가를 한 커밋에 섞음

### 5. 최소 구현 원칙

GREEN 단계에서는 테스트를 통과시키는 **가장 단순한 코드**만 작성하세요.

---

## 트러블슈팅

### 테스트가 계속 실패함

1. `/test-run`으로 정확한 실패 원인 파악
2. RED 단계인지 확인 (의도된 실패인가?)
3. GREEN 단계라면 코드 재검토
4. 필요시 `/red`부터 다시 시작

### 어떤 명령어를 써야 할지 모르겠음

1. `/status`로 현재 상태 확인
2. 현재 단계에 맞는 명령어 사용:
   - RED → `/green` 또는 `/test-run`
   - GREEN → `/refactor` 또는 `/mark`

### plan.md와 실제 진행이 안 맞음

1. `/plan-view`로 현재 plan 확인
2. `/plan-add`로 누락된 테스트 추가
3. 잘못된 마크가 있다면 plan.md 직접 수정

### 리팩토링 후 테스트 실패

1. **즉시 변경 사항 되돌리기** (`git checkout`)
2. 더 작은 단위로 리팩토링
3. 각 단계마다 `/test-run` 실행

---

## 치트 시트

| 명령어 | 용도 | 사용 시점 |
|--------|------|-----------|
| `/go` | 자동 TDD 사이클 | 빠르게 진행하고 싶을 때 |
| `/next` | 다음 테스트 미리보기 | 계획 확인 시 |
| `/status` | 현재 상태 확인 | 길을 잃었을 때 |
| `/red` | 실패 테스트 작성 | RED 단계 |
| `/green` | 최소 구현 | GREEN 단계 |
| `/refactor` | 코드 개선 | REFACTOR 단계 |
| `/test-run` | 테스트 실행 | 매 단계 사이 |
| `/mark` | 완료 표시 | 테스트 완료 시 |
| `/tidy` | 구조 개선 | 기능 추가 전 |
| `/commit-structural` | 구조 변경 커밋 | Tidy 후 |
| `/commit-behavioral` | 기능 변경 커밋 | 기능 완료 시 |

### 일반적인 워크플로우

**초보자 (자동)**:
```
/go → /mark → 반복
```

**중급자 (수동)**:
```
/next → /red → /test-run → /green → /test-run → /refactor → /mark
```

**고급자 (Tidy First)**:
```
/tidy → /commit-structural → /go → /commit-behavioral → 반복
```

---

### 참고 자료

- Kent Beck - "Test-Driven Development: By Example"
- Kent Beck - "Tidy First?"
- Martin Fowler - "Refactoring"
- [Worktree Parallel Skill 가이드](docs/worktree-parallel.md)

---

**Happy TDD! 🧪**
