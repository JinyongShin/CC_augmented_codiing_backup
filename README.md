# Augmented Coding Rules for Claude Code

Kent Beck의 Test-Driven Development와 Tidy First 원칙을 Claude Code에 적용하는 구성 모음입니다.

## 구성 요소

| 디렉토리 | 설치 경로 | 역할 |
|----------|-----------|------|
| `tdd/` | `.claude/skills/tdd/` | TDD 전체 워크플로우 skill (필수) |
| `rules/uv.md` | `.claude/rules/uv.md` | uv 패키지 매니저 정책 (선택, Python 프로젝트) |
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
# 1. TDD skill 설치 (필수)
#    /tdd <command> 형태로 TDD 전체 워크플로우를 제어
mkdir -p .claude/skills
cp -r tdd/ .claude/skills/tdd/

# 2. uv 패키지 매니저 정책 적용 (선택 - Python 프로젝트)
#    Claude Code가 pip 대신 uv를 자동으로 사용하도록 설정
mkdir -p .claude/rules
cp rules/uv.md .claude/rules/

# 3. 병렬 개발 skill 설치 (선택)
#    여러 독립적인 작업을 동시에 개발할 때 사용
cp -r worktree-parallel/ .claude/skills/worktree-parallel/
```

### plan.md 작성

`/tdd plan-init`으로 대화형으로 생성하거나, `plan.md.example`을 참고해 직접 작성합니다.

```markdown
## Tests

- [ ] Test 1: User should be able to create account with valid email
- [ ] Test 2: User registration should reject invalid email formats
- [ ] Test 3: User password should be hashed before storage
```

### 첫 번째 TDD 사이클

rules 설치 후 Claude Code는 자동으로 TDD 방식으로 개발합니다.
`/tdd` 커맨드는 그 위에서 단계별 진행을 직접 제어하고 싶을 때 사용합니다.

```bash
/tdd plan-init   # plan.md 생성 (최초 1회)
/tdd go          # 다음 테스트의 전체 TDD 사이클(Red → Green → Refactor) 자동 실행
```

---

## 핵심 워크플로우

> **`/tdd` skill이 TDD 워크플로우 전체를 담당합니다.** 단계별 진행을 직접 제어하고 싶을 때 서브커맨드를 사용하세요.

### 기본 TDD 사이클

```
1. /tdd go       → 다음 테스트 자동 실행 (Red → Green → Refactor)
2. /tdd mark     → 테스트 완료 표시
3. 반복
```

### 수동 제어 워크플로우

더 세밀한 제어가 필요한 경우:

```
1. /tdd next         → 다음 테스트 미리보기
2. /tdd red          → 실패하는 테스트 작성
3. /tdd test-run     → 테스트 실행 (실패 확인)
4. /tdd green        → 최소 코드로 테스트 통과
5. /tdd test-run     → 테스트 실행 (통과 확인)
6. /tdd refactor     → 코드 개선 (선택)
7. /tdd test-run     → 테스트 실행 (여전히 통과하는지 확인)
8. /tdd mark         → 완료 표시
```

### Tidy First 워크플로우

구조적 변경과 행동적 변경을 분리:

```
1. /tdd tidy                    → 구조적 개선 제안 및 적용
2. /tdd test-run                → 행동 변경 없음 확인
3. /tdd commit-structural       → 구조적 변경 커밋
4. /tdd go                      → 새 기능 구현 (행동 변경)
5. /tdd commit-behavioral       → 행동 변경 커밋
```

---

## 명령어 레퍼런스

전체 명령어 상세 설명은 **[docs/commands.md](docs/commands.md)** 를 참조하세요.

| 명령어 | 용도 |
|--------|------|
| `/tdd plan-init` | plan.md 최초 생성 |
| `/tdd go` | 자동 TDD 사이클 |
| `/tdd red` | RED 단계 - 실패 테스트 작성 |
| `/tdd green` | GREEN 단계 - 최소 구현 |
| `/tdd refactor` | REFACTOR 단계 - 코드 개선 |
| `/tdd test-run` | 테스트 실행 |
| `/tdd mark` | 테스트 완료 표시 |
| `/tdd next` | 다음 테스트 미리보기 |
| `/tdd status` | 현재 TDD 상태 확인 |
| `/tdd tidy` | 구조적 개선 (Tidy First) |
| `/tdd commit-structural` | 구조적 변경 커밋 |
| `/tdd commit-behavioral` | 행동 변경 커밋 |
| `/tdd plan-view` | 전체 계획 보기 |
| `/tdd plan-add` | 새 테스트 추가 |
| `/tdd plan-reset` | 모든 마크 초기화 |

---

## 실전 예제

상세 예제는 **[docs/examples.md](docs/examples.md)** 를 참조하세요.

- **예제 1**: 간단한 기능 추가 (`/tdd go` → `/tdd mark` 반복)
- **예제 2**: 수동 제어로 세밀하게 작업
- **예제 3**: Tidy First 워크플로우

---

## 베스트 프랙티스

### 1. TDD 사이클 준수

✅ **좋은 예**:
```
/tdd red → /tdd test-run → /tdd green → /tdd test-run → /tdd refactor → /tdd test-run → /tdd mark
```

❌ **나쁜 예**:
```
테스트와 구현을 동시에 작성 (TDD 아님!)
```

### 2. 작은 단계로 진행

✅ 한 번에 하나의 테스트, 한 번에 하나의 리팩토링, 작고 빈번한 커밋

❌ 여러 테스트를 한 번에 작성, 큰 리팩토링을 한 번에 수행

### 3. 테스트를 자주 실행

테스트 작성 후, 코드 작성 후, 리팩토링 후 — 매번 `/tdd test-run`

### 4. 구조적/행동적 변경 분리

✅ `/tdd tidy` → `/tdd commit-structural` → `/tdd go` → `/tdd commit-behavioral`

❌ 구조 변경과 기능 추가를 한 커밋에 섞음

### 5. 최소 구현 원칙

GREEN 단계에서는 테스트를 통과시키는 **가장 단순한 코드**만 작성하세요.

---

## 트러블슈팅

### 테스트가 계속 실패함

1. `/tdd test-run`으로 정확한 실패 원인 파악
2. RED 단계인지 확인 (의도된 실패인가?)
3. GREEN 단계라면 코드 재검토
4. 필요시 `/tdd red`부터 다시 시작

### 어떤 명령어를 써야 할지 모르겠음

1. `/tdd status`로 현재 상태 확인
2. 현재 단계에 맞는 명령어 사용:
   - RED → `/tdd green` 또는 `/tdd test-run`
   - GREEN → `/tdd refactor` 또는 `/tdd mark`

### plan.md와 실제 진행이 안 맞음

1. `/tdd plan-view`로 현재 plan 확인
2. `/tdd plan-add`로 누락된 테스트 추가
3. 잘못된 마크가 있다면 plan.md 직접 수정

### 리팩토링 후 테스트 실패

1. **즉시 변경 사항 되돌리기** (`git checkout`)
2. 더 작은 단위로 리팩토링
3. 각 단계마다 `/tdd test-run` 실행

---

## 치트 시트

| 명령어 | 용도 | 사용 시점 |
|--------|------|-----------|
| `/tdd go` | 자동 TDD 사이클 | 빠르게 진행하고 싶을 때 |
| `/tdd next` | 다음 테스트 미리보기 | 계획 확인 시 |
| `/tdd status` | 현재 상태 확인 | 길을 잃었을 때 |
| `/tdd red` | 실패 테스트 작성 | RED 단계 |
| `/tdd green` | 최소 구현 | GREEN 단계 |
| `/tdd refactor` | 코드 개선 | REFACTOR 단계 |
| `/tdd test-run` | 테스트 실행 | 매 단계 사이 |
| `/tdd mark` | 완료 표시 | 테스트 완료 시 |
| `/tdd tidy` | 구조 개선 | 기능 추가 전 |
| `/tdd commit-structural` | 구조 변경 커밋 | Tidy 후 |
| `/tdd commit-behavioral` | 기능 변경 커밋 | 기능 완료 시 |

### 일반적인 워크플로우

**초보자 (자동)**:
```
/tdd go → /tdd mark → 반복
```

**중급자 (수동)**:
```
/tdd next → /tdd red → /tdd test-run → /tdd green → /tdd test-run → /tdd refactor → /tdd mark
```

**고급자 (Tidy First)**:
```
/tdd tidy → /tdd commit-structural → /tdd go → /tdd commit-behavioral → 반복
```

---

### 참고 자료

- Kent Beck - "Test-Driven Development: By Example"
- Kent Beck - "Tidy First?"
- Martin Fowler - "Refactoring"
- [Worktree Parallel Skill 가이드](docs/worktree-parallel.md)

---

**Happy TDD! 🧪**
