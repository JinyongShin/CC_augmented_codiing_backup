# 실전 예제

---

## 예제 1: 간단한 기능 추가

**시나리오**: 이메일 검증 기능 추가

### Step 1: Plan 작성

```bash
/tdd plan-init
```

또는 직접 작성:
```markdown
## Tests
- [ ] Should accept valid email with @ symbol
- [ ] Should reject email without @ symbol
- [ ] Should reject empty email
```

### Step 2: 첫 번째 테스트 실행

```bash
/tdd go
```

Claude가 자동으로:
1. RED: 첫 번째 테스트 작성 및 실패 확인
2. GREEN: 최소 코드 구현
3. REFACTOR: 개선 제안 (필요시)

### Step 3: 완료 표시

```bash
/tdd mark
```

### Step 4: 반복

나머지 테스트들도 `/tdd go` → `/tdd mark` 반복

---

## 예제 2: 수동 제어로 세밀하게 작업

**시나리오**: 복잡한 비즈니스 로직 구현

### Step 1: 다음 테스트 확인

```bash
/tdd next
```

### Step 2: 실패하는 테스트 작성

```bash
/tdd red
```

```python
def test_user_registration_with_weak_password():
    """약한 비밀번호는 거부되어야 함"""
    with pytest.raises(WeakPasswordError):
        User.register(
            email="user@example.com",
            password="123"
        )
```

### Step 3: 테스트 실행 (실패 확인)

```bash
/tdd test-run
```

### Step 4: 최소 코드 구현

```bash
/tdd green
```

```python
class User:
    @staticmethod
    def register(email, password):
        if len(password) < 8:
            raise WeakPasswordError("Password too short")
        # ... 나머지 로직
```

### Step 5: 테스트 실행 (통과 확인)

```bash
/tdd test-run
```

### Step 6: 리팩토링

```bash
/tdd refactor
```

중복 제거, 매직 넘버를 상수로 추출 등

### Step 7: 완료

```bash
/tdd mark
```

---

## 예제 3: Tidy First 워크플로우

**시나리오**: 기능 추가 전에 코드 정리

### Step 1: 현재 상태 확인

```bash
/tdd status
```

모든 테스트가 통과하는지 확인

### Step 2: 구조적 개선

```bash
/tdd tidy
```

예: 긴 메서드를 작은 메서드들로 분리

```python
# Before (Tidy 전)
def process_user(data):
    # 50줄의 긴 메서드
    ...

# After (Tidy 후)
def process_user(data):
    user = extract_user_data(data)
    validate_user(user)
    save_user(user)
    return user
```

### Step 3: 테스트로 검증

```bash
/tdd test-run
```

행동이 변하지 않았는지 확인

### Step 4: 구조적 변경 커밋

```bash
/tdd commit-structural
```

### Step 5: 이제 새 기능 추가

```bash
/tdd go
```

### Step 6: 행동 변경 커밋

```bash
/tdd commit-behavioral
```
