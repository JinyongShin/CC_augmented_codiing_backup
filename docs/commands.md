# 명령어 레퍼런스

모든 TDD 명령어의 상세 설명입니다. 모든 명령어는 `/tdd <command>` 형식으로 사용합니다.

---

## 🎯 핵심 TDD 명령어

### `/tdd go`
**용도**: 다음 테스트 자동 실행
**설명**: plan.md에서 첫 번째 unmarked 테스트를 찾아 Red → Green → Refactor 전체 사이클을 자동으로 진행합니다.

**언제 사용하나요?**
- 빠르게 TDD 사이클을 진행하고 싶을 때
- TDD 프로세스를 자동화하고 싶을 때

---

### `/tdd next`
**용도**: 다음 테스트 미리보기
**설명**: 다음에 구현할 테스트를 보여주기만 하고 실행하지 않습니다.

**출력 예시**:
```
📋 Next Test in Plan:

[ ] User should be able to create account with valid email

Position: Test 1 of 10
Remaining: 10 tests

To execute this test, use: /tdd go
```

**언제 사용하나요?**
- 다음 작업을 계획할 때
- 전체 진행 상황을 파악하고 싶을 때

---

### `/tdd mark`
**용도**: 현재 테스트 완료 표시
**설명**: plan.md에서 `- [ ]`를 `- [x]`로 변경합니다.

**주의사항**:
- 모든 테스트가 통과해야 합니다
- TDD 사이클(Red → Green → Refactor)이 완료되어야 합니다

---

### `/tdd status`
**용도**: TDD 상태 확인
**설명**: 현재 진행 상황, TDD 단계, 테스트 상태를 종합적으로 보여줍니다.

**출력 예시**:
```
📊 TDD Status Report

Progress: 3/10 tests complete (30%)
[███░░░░░░░]

🔄 Current Phase: GREEN

📋 Current Test:
- [ ] User registration should reject invalid email

✅ Test Status: 15 passing, 0 failed

Next Action: Use /tdd refactor or /tdd mark
```

---

## 🔄 TDD 단계별 명령어

### `/tdd red`
**용도**: RED 단계 - 실패하는 테스트 작성
**설명**: 구현 코드 없이 테스트만 작성하고 실패를 확인합니다.

**원칙**:
- 한 번에 하나의 테스트만 작성
- 가장 단순한 실패하는 테스트 작성
- 명확한 assertion 사용

**예시**:
```python
def test_should_reject_invalid_email():
    """유효하지 않은 이메일로 사용자 등록 시 예외 발생"""
    # Given
    invalid_email = "not-an-email"

    # When & Then
    with pytest.raises(ValidationError):
        User.register(email=invalid_email)
```

---

### `/tdd green`
**용도**: GREEN 단계 - 최소 코드로 테스트 통과
**설명**: 테스트를 통과시키기 위한 최소한의 코드만 작성합니다.

**원칙**:
- **최소한의 코드**만 작성 (가장 중요!)
- 추가 기능 구현 금지
- 하드코딩도 허용 (나중에 일반화)

**좋은 예**:
```python
def validate_email(email):
    if "@" not in email:
        raise ValidationError("Invalid email")
    return True
```

**나쁜 예** (과도한 구현):
```python
def validate_email(email):
    # 정규식, 도메인 검증, MX 레코드 확인 등...
    # 테스트가 요구하지 않는 기능들
```

---

### `/tdd refactor`
**용도**: REFACTOR 단계 - 코드 개선
**설명**: 테스트를 통과 상태로 유지하면서 코드 구조를 개선합니다.

**리팩토링 대상**:
- 중복 코드 (DRY 원칙)
- 불명확한 변수명
- 긴 메서드
- 복잡한 조건문
- 매직 넘버

**프로세스**:
1. 한 번에 하나의 리팩토링만 수행
2. 각 리팩토링 후 테스트 실행
3. 테스트 실패 시 즉시 되돌리기

---

### `/tdd test-run`
**용도**: 테스트 실행
**설명**: pytest를 `-v -s` 옵션으로 실행하여 상세한 결과를 확인합니다.

**실행 명령어**: `pytest -v -s`

**언제 사용하나요?**
- 각 TDD 단계 사이에
- 리팩토링 후 검증할 때
- 현재 상태를 확인하고 싶을 때

---

## 🧹 Tidy First 명령어

### `/tdd tidy`
**용도**: 구조적 변경 제안 및 적용
**설명**: 행동 변경 없이 코드 구조만 개선합니다.

**구조적 변경 예시**:
- 변수/함수/클래스 이름 변경
- 메서드 추출
- 코드 이동
- 포맷팅 개선

**중요**: 모든 테스트가 통과한 상태에서만 실행하세요.

**프로세스**:
```
1. 테스트 통과 확인
2. 구조적 변경 적용
3. 테스트 실행 (여전히 통과해야 함)
4. /tdd commit-structural로 커밋
```

---

## 📋 Plan 관리 명령어

### `/tdd plan-init`
**용도**: plan.md 최초 생성
**설명**: 대화형으로 테스트 계획 파일을 생성합니다. 프로젝트를 시작할 때 최초 1회 실행합니다.

**프로세스**:
1. 개발할 기능/모듈 이름 입력
2. 초기 테스트 목록 작성 (Claude가 도움)
3. plan.md 생성

---

### `/tdd plan-view`
**용도**: 전체 테스트 계획 보기
**설명**: plan.md의 전체 내용과 진행 통계를 표시합니다.

---

### `/tdd plan-add`
**용도**: 새 테스트 추가
**설명**: plan.md에 새로운 테스트를 추가합니다.

```bash
/tdd plan-add Should validate password strength
```

또는 인터랙티브하게:
```bash
/tdd plan-add
```
그러면 테스트 설명을 물어봅니다.

---

### `/tdd plan-reset`
**용도**: 모든 테스트 마크 초기화
**설명**: 모든 `[x]`를 `[ ]`로 변경합니다.

**⚠️ 주의**: 파괴적 작업이므로 확인 절차가 있습니다.

**사용 사례**:
- 동일한 테스트를 다시 실습할 때
- 새로운 반복 시작 시

---

## 💾 커밋 명령어

### `/tdd commit-structural`
**용도**: 구조적 변경만 커밋
**설명**: 행동 변경이 없는 순수 구조적 변경을 커밋합니다.

**커밋 전 검증**:
- ✅ 모든 테스트 통과
- ✅ 린터 경고 없음
- ✅ 행동 변경 없음
- ✅ 구조적 변경만 있음

**커밋 메시지 예시**:
```
structural: Extract email validation into separate function

- Moved validation logic from User.register to validate_email()
- Improves code reusability and testability

All tests passing. No behavior changes.
```

---

### `/tdd commit-behavioral`
**용도**: 행동 변경 커밋
**설명**: 새 기능, 버그 수정 등 행동 변경을 커밋합니다.

**커밋 전 검증**:
- ✅ 모든 테스트 통과
- ✅ TDD 사이클 완료
- ✅ 린터 경고 없음
- ✅ 구조적 변경이 먼저 커밋되었음

**커밋 메시지 예시**:
```
feat: Add email validation to user registration

- Implemented validate_email() function
- Added tests for valid and invalid email formats
- User.register() now validates email before saving

TDD cycle complete. All tests passing.
```
