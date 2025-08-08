## Deploy Check

배포 대상 환경에 안전하게 배포할 수 있는지 사전에 검증하는 의도 정의 명령입니다.

### Usage

```bash
/deploy-check [--env 
	<staging|production|custom>] [--smoke-url <url>] [--migrations] [--strict]
```

### Options

- `--env <staging|production|custom>` : 대상 환경 (요구되는 게이트/기준에 영향)
- `--smoke-url <url>` : 배포 후 헬스/스모크 확인 엔드포인트 (가능한 경우)
- `--migrations` : DB 마이그레이션 준비 상태 점검 포함 (dry-run/plan)
- `--strict` : 더 엄격한 게이트 적용 (취약점 0, TODO/FIXME 없음, 커버리지 임계치 등)
- `--template` : 표준 Markdown 체크리스트 템플릿 출력 (CI 아티팩트/수동 점검용)

### 예시

```bash
# 표준 체크리스트 템플릿 출력
/deploy-check --template
"배포 티켓에 붙여넣을 수 있는 Markdown 체크리스트를 출력해 주세요."
```

```bash
# 스테이징 사전 점검
/deploy-check --env staging --smoke-url https://staging.example.com/health
"아래의 build/test/audit 출력과 환경 변수 요약을 사용해 준비 완료 여부를 판단하고, 차단 이슈와 해결책을 제시해 주세요."

# 프로덕션 (마이그레이션 포함)
/deploy-check --env production --migrations --strict
"다운타임 최소를 전제로, 롤백 전략과 설정 드리프트도 함께 검증해 주세요."
```

### Claude 연계

아래 정보를 간결히 정리해 제공한 뒤 실행하세요 (로그/환경/마이그레이션 계획/인프라 요약 등). 이후 다음을 호출합니다:

```bash
/deploy-check --env production --migrations --strict
"각 게이트의 PASS/FAIL 체크리스트를 생성하고, FAIL 항목마다 실행 가능한 수정 단계/명령을 제시하세요. 위험 평가, 롤백 계획, 배포 후 스모크 단계(curl <url> / 로그 확인)도 포함해 주세요."
```

### 이 명령이 하는 일

- 배포 전 게이트를 단일 체크리스트로 통합
- 사용자가 제공한 컨텍스트를 바탕으로 PASS/FAIL 판단
- 구체적인 수정 단계, 최소 스모크 플랜, 롤백 플랜 제시

### 템플릿 (발췌)

```
# 배포 준비 체크리스트
- [ ] 브랜치 클린 (미커밋 변경 없음)
- [ ] main 동기화 (HEAD == origin/main 또는 합당한 근거)
- [ ] Lint 통과
- [ ] 타입체크 통과 (해당 시)
- [ ] 단위 테스트 통과
- [ ] E2E 테스트 통과 (또는 범위/사유 명시)
- [ ] 빌드 성공
- [ ] 보안 감사: 치명/높음 0 (있다면 완화책 명시)
- [ ] 필수 환경변수: API_URL, DATABASE_URL, SECRET_KEY
- [ ] 마이그레이션 검토 완료 (plan/dry-run 첨부)
- [ ] 인프라/설정 드리프트 확인 (IaC, 이미지 태그, replicas)
- [ ] 롤백 계획 문서화
- [ ] 배포 후 스모크: curl <SMOKE_URL> 및 로그 확인
```

### 관련 명령

- `/pr-check` – PR 전 품질 게이트
- `/test-e2e-local` – 로컬 E2E 검증
- `/check-github-ci` – CI 상태 추적
