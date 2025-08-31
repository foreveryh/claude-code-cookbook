## PR 병합

포괄적인 품질 검증 및 승인 후 Pull Request를 자동으로 병합합니다.

### 사용법

```bash
# 품질 게이트 통과 후 자동 병합
/pr-merge
"모든 품질 게이트를 검증하고 현재 PR을 자동으로 병합"

# 특정 PR을 검증하여 병합
/pr-merge --pr 123
"모든 검사 통과 후 PR #123을 검증하여 병합"

# 병합 준비 상태를 확인하는 드라이 런
/pr-merge --dry-run
"실제로 병합하지 않고 PR이 병합 준비가 되었는지 확인"
```

### 기본 예제

```bash
# 완전한 품질 검증 및 병합
gh pr checks && gh pr view --json reviewDecision
"CI 상태와 승인 상태를 확인하고, 모든 조건이 충족되면 병합 진행"

# 안전 검사를 포함한 조건부 병합
gh pr view --json isDraft,mergeable,reviewDecision
"병합 전 초안 상태, 병합 충돌, 리뷰 승인 확인"
```

### 병합 전 검증 체크리스트

#### 1. CI 상태 확인
```bash
# 모든 CI 검사가 통과하는지 확인
gh pr checks --required
"모든 필수 CI 검사가 녹색인지 확인"
```

#### 2. 리뷰 상태 확인
```bash
# 승인 상태 확인
gh pr view --json reviewDecision,reviews
"PR이 필요한 승인을 받았고 대기 중인 변경 요청이 없는지 확인"
```

#### 3. 브랜치 상태 확인
```bash
# 병합 충돌 확인
gh pr view --json mergeable,mergeableState
"병합 충돌이 존재하지 않는지 확인"
```

#### 4. 초안 상태 확인
```bash
# PR이 초안이 아닌지 확인
gh pr view --json isDraft
"PR이 리뷰 준비 완료로 표시되어 있는지 확인"
```

### 병합 전략

#### 기본값: 스쿼시 병합
```bash
# 스쿼시 병합 (기능 브랜치에 권장)
gh pr merge --squash --delete-branch
"모든 커밋을 단일 커밋으로 결합하고 기능 브랜치 삭제"
```

#### 대안: 병합 커밋
```bash
# 병합 커밋 생성 (릴리스 브랜치용)
gh pr merge --merge --delete-branch
"커밋 히스토리를 보존하는 명시적 병합 커밋 생성"
```

#### 대안: 리베이스 병합
```bash
# 리베이스 병합 (선형 히스토리용)
gh pr merge --rebase --delete-branch
"베이스 브랜치 위에 커밋을 재실행"
```

### 안전 메커니즘

#### 1. 필수 조건
- ✅ 모든 필수 CI 검사가 통과해야 함
- ✅ 코드 소유자로부터 최소 한 개의 승인
- ✅ 대기 중인 변경 요청이 없음
- ✅ 병합 충돌이 없음
- ✅ PR이 초안 상태가 아님
- ✅ 브랜치 보호 규칙이 만족됨

#### 2. 선택적 품질 게이트
- ⚠️ 코드 커버리지 임계값 충족
- ⚠️ 보안 스캔 통과
- ⚠️ 성능 벤치마크 허용 가능
- ⚠️ 문서 업데이트됨

#### 3. 응급 우회 (관리자만)
```bash
# 관리자 권한으로 강제 병합 (주의해서 사용)
/pr-merge --force --admin
"보호 규칙 재정의 (관리자 권한 필요)"
```

### 실행 플로우

```bash
#!/bin/bash

# 1. 현재 PR 감지
detect_current_pr() {
  local current_branch=$(git branch --show-current)
  gh pr list --head $current_branch --json number --jq '.[0].number'
}

# 2. 포괄적 검증
verify_merge_readiness() {
  local pr_number=$1
  
  # CI 상태 확인
  local ci_status=$(gh pr checks $pr_number --required --json state --jq '.[] | select(.state != "SUCCESS") | length')
  if [ $ci_status -gt 0 ]; then
    echo "❌ 필수 CI 검사가 통과하지 않음"
    return 1
  fi
  
  # 리뷰 상태 확인
  local review_decision=$(gh pr view $pr_number --json reviewDecision --jq '.reviewDecision')
  if [ "$review_decision" != "APPROVED" ]; then
    echo "❌ PR이 승인되지 않음 (상태: $review_decision)"
    return 1
  fi
  
  # 초안 상태 확인
  local is_draft=$(gh pr view $pr_number --json isDraft --jq '.isDraft')
  if [ "$is_draft" = "true" ]; then
    echo "❌ PR이 여전히 초안 상태임"
    return 1
  fi
  
  # 병합 충돌 확인
  local mergeable=$(gh pr view $pr_number --json mergeable --jq '.mergeable')
  if [ "$mergeable" != "MERGEABLE" ]; then
    echo "❌ PR에 병합 충돌이 있음"
    return 1
  fi
  
  echo "✅ 모든 병합 조건이 만족됨"
  return 0
}

# 3. 병합 실행
execute_merge() {
  local pr_number=$1
  local strategy=${2:-"squash"}
  
  case $strategy in
    "squash")
      gh pr merge $pr_number --squash --delete-branch
      ;;
    "merge")
      gh pr merge $pr_number --merge --delete-branch
      ;;
    "rebase")
      gh pr merge $pr_number --rebase --delete-branch
      ;;
    *)
      echo "❌ 알 수 없는 병합 전략: $strategy"
      return 1
      ;;
  esac
  
  echo "✅ PR $pr_number이 성공적으로 병합됨"
}

# 메인 실행
main() {
  local pr_number=$(detect_current_pr)
  
  if [ -z "$pr_number" ]; then
    echo "❌ 현재 브랜치에 대한 PR을 찾을 수 없음"
    exit 1
  fi
  
  echo "🔍 PR #$pr_number의 병합 준비 상태 검증 중"
  
  if verify_merge_readiness $pr_number; then
    if [ "$DRY_RUN" = "true" ]; then
      echo "✅ [드라이 런] PR #$pr_number이 병합 준비 완료"
    else
      echo "🚀 병합 진행 중..."
      execute_merge $pr_number $MERGE_STRATEGY
    fi
  else
    echo "❌ PR #$pr_number이 병합 준비가 되지 않음"
    exit 1
  fi
}
```

### 옵션

- `--pr <번호>`: PR 번호 지정 (생략 시 현재 브랜치에서 자동 감지)
- `--strategy <squash|merge|rebase>`: 병합 전략 선택 (기본값: squash)
- `--dry-run`: 실제로 병합하지 않고 병합 준비 상태 확인
- `--force`: 보호 규칙 재정의 (관리자만)
- `--no-delete-branch`: 병합 후 기능 브랜치 유지

### 기존 워크플로우와의 통합

```bash
# 완전 자동화 워크플로우
/pr-check          # 품질 검증
/pr-review         # 포괄적 리뷰
/pr-feedback       # 문제 해결
/pr-auto-update    # 메타데이터 업데이트
/pr-merge          # 준비 완료 시 자동 병합
```

### 일반적인 사용 사례

#### 1. 기능 브랜치 완료
```bash
# 개발 완료 후
/pr-merge --strategy squash
"모든 기능 커밋을 깔끔한 단일 커밋으로 스쿼시"
```

#### 2. 핫픽스 배포
```bash
# 즉시 병합이 필요한 응급 수정
/pr-merge --strategy merge
"감사 추적을 위해 정확한 커밋 히스토리 보존"
```

#### 3. 릴리스 브랜치 통합
```bash
# 전체 히스토리와 함께 릴리스 브랜치 병합
/pr-merge --strategy merge --no-delete-branch
"향후 참조를 위해 브랜치를 보존하면서 릴리스 통합"
```

### 문제 해결

#### 일반적인 문제
1. **PR이 승인되지 않음**: 코드 소유자에게 리뷰 요청
2. **CI 검사 실패**: `/pr-feedback`을 사용하여 분석 및 수정
3. **병합 충돌**: 충돌 해결 후 브랜치 업데이트
4. **초안 상태**: `gh pr ready`를 사용하여 리뷰 준비 완료로 표시
5. **브랜치 보호 누락**: 저장소 관리자에게 문의

#### 오류 복구
```bash
# 병합이 실패하면 문제 분석
gh pr view $PR_NUMBER --json mergeableState,statusCheckRollup
"상세한 병합 상태와 CI 결과 확인"

# 문제 수정 후 재시도
/pr-feedback && /pr-merge --dry-run
"문제 해결 후 재시도 전 검증"
```

### 보안 고려사항

1. **권한 검증**: 사용자가 병합 권한을 가지고 있는지 확인
2. **브랜치 보호**: 구성된 모든 보호 규칙 준수
3. **감사 추적**: 사용자 속성과 함께 모든 병합 작업 기록
4. **롤백 계획**: 필요 시 병합 취소 절차 문서화

### 주의사항

- **GitHub CLI 필요**: `gh`가 인증되어 있어야 함
- **브랜치 권한**: 사용자가 대상 브랜치에 대한 쓰기 액세스 권한을 가져야 함
- **보호 규칙**: 모든 저장소 보호 규칙이 만족되어야 함
- **알림**: 팀 멤버들은 GitHub의 표준 병합 알림을 통해 통지받음