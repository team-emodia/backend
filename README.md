# Emodia Backend

Django REST Framework 기반의 감정 기록 및 운동 관리 백엔드 서버입니다.

## 기술 스택

- **Python**: 3.11+
- **Django**: 4.2.24
- **Django REST Framework**: 3.16.1
- **Database**: MySQL
- **Package Manager**: Poetry
- **AI/ML**: MediaPipe (자세 감지), OpenCV

## 프로젝트 구조

```
backend/
├── src/backend/
│   ├── manage.py
│   ├── testemo/           # Django 프로젝트 설정
│   ├── emodia/            # 메인 앱 (감정 기록, 운동 세션)
│   ├── users/             # 사용자 관리
│   ├── profiles/          # 사용자 프로필
│   └── media/
│       └── videos/        # 운동 영상 파일
├── pyproject.toml         # Poetry 의존성 관리
└── README.md
```

## 초기 설정 및 실행

### 1. 사전 요구사항

- Python 3.11 이상
- Poetry (없다면 설치: `pip install poetry`)
- MySQL 서버

### 2. 저장소 클론

```bash
git clone <repository-url>
cd final_emo/backend
```

### 3. Poetry로 의존성 설치

```bash
# Poetry 가상환경 생성 및 의존성 설치
poetry install

# 가상환경 활성화
poetry shell
```

### 4. 환경변수 설정

`src/backend/.env` 파일 생성:

```env
# Database
DB_NAME=your_database_name
DB_USER=your_database_user
DB_PASSWORD=your_database_password
DB_HOST=localhost
DB_PORT=3306

# Django
SECRET_KEY=your-secret-key-here
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1

# CORS
CORS_ALLOWED_ORIGINS=http://localhost:3000
```

### 5. 데이터베이스 마이그레이션

```bash
cd src/backend

# 마이그레이션 파일 생성
poetry run python manage.py makemigrations

# 데이터베이스에 적용 (초기 데이터 자동 삽입 포함)
poetry run python manage.py migrate

# 확인: Sports 5개, EmotionVideo 24개가 자동으로 생성됨
```

**자동으로 삽입되는 초기 데이터:**
- **Sports**: 5개 (목·어깨 스트레칭, 전신 스트레칭, 요가, 필라테스, 코어 운동)
- **EmotionVideo**: 24개 (자세교정 4개, 초급 14개, 중급 4개, 고급 2개)
  - 모든 영상이 적절한 Sports에 자동 연결됨
  - 예: 목/어깨 영상 → 목·어깨 스트레칭, 요가 영상 → 요가

**참고**: 사용자 데이터(EmotionRecord, WorkoutSession 등)는 앱 사용 중 자동 생성됩니다.

### 6. 관리자 계정 생성

```bash
poetry run python manage.py createsuperuser
```

### 7. 개발 서버 실행

```bash
poetry run python manage.py runserver
```

서버 주소: `http://127.0.0.1:8000`

## 주요 기능

### 1. 감정 기록 API
- 일별 감정 기록 생성/조회/수정/삭제
- 월별 감정 캘린더 데이터 조회
- 감정별 이모지 및 한글 이름 자동 매핑

### 2. 운동 관리 API
- 운동 세션 시작/종료
- 실시간 포즈 좌표 전송 및 피드백
- 운동 영상 목록 조회 (난이도, 부위, 운동 종류별 필터링)

### 3. 자세 감지 AI
- MediaPipe 기반 실시간 자세 분석
- 목/어깨 스트레칭 자세 피드백 (좌/우)
- 운동 정확도 실시간 피드백

## Poetry 주요 명령어

```bash
# 의존성 설치
poetry install

# 가상환경 활성화
poetry shell

# 패키지 추가
poetry add package-name

# 개발 의존성 추가
poetry add --group dev package-name

# 의존성 업데이트
poetry update

# Django 명령어 실행
poetry run python manage.py <command>

# 가상환경 정보 확인
poetry env info
```

## 유용한 Django 명령어

```bash
# 데이터베이스 쉘
poetry run python manage.py dbshell

# Django 쉘
poetry run python manage.py shell

# 초기 영상 데이터 재생성 (선택사항)
poetry run python manage.py populate_videos

# 테스트 실행
poetry run python manage.py test

# 정적 파일 수집
poetry run python manage.py collectstatic
```

## API 엔드포인트

### 인증
- `POST /api/auth/register/` - 회원가입
- `POST /api/auth/login/` - 로그인
- `POST /api/auth/token/refresh/` - 토큰 갱신

### 감정 기록
- `GET/POST /api/emotions/` - 감정 기록 목록 조회/생성
- `GET/PUT/DELETE /api/emotions/{id}/` - 특정 감정 기록 조회/수정/삭제
- `GET /api/emotions/date/{date}/` - 특정 날짜의 감정 기록 조회
- `POST /api/emotions/save/` - 감정 기록 생성 또는 수정
- `GET /api/emotions/calendar/{year}/{month}/` - 월별 감정 캘린더

### 운동 관리
- `POST /api/workout/start/` - 운동 세션 시작
- `PATCH /api/workout/{session_id}/end/` - 운동 세션 종료
- `GET /api/workout/sessions/` - 운동 세션 목록
- `POST /api/pose/submit/` - 포즈 좌표 전송 및 피드백

### 영상 관리
- `GET /api/sports/` - Sports 목록 조회
- `GET /api/videos/` - 영상 목록 조회 (필터링 가능)
- `GET /api/videos/{id}/` - 특정 영상 상세 조회

**영상 필터링 옵션:**
- `?difficulty=자세교정` - 난이도별 (초급, 중급, 고급, 자세교정)
- `?body_part=목` - 부위별 (전신, 목, 어깨, 목어깨, 등, 골반, 코어)
- `?exercise_type=스트레칭` - 운동 종류별
- `?duration_min=5&duration_max=15` - 시간 범위

## 트러블슈팅

### Poetry 설치 문제
```bash
# Poetry 설치
curl -sSL https://install.python-poetry.org | python3 -

# 또는 pip로 설치
pip install poetry
```

### MySQL 연결 오류
- `.env` 파일의 데이터베이스 정보 확인
- MySQL 서버 실행 여부 확인
- 데이터베이스 생성: `CREATE DATABASE your_database_name;`

### Migration 오류
```bash
# 마이그레이션 초기화
poetry run python manage.py migrate --fake emodia zero
poetry run python manage.py migrate emodia
```

### 영상 파일 없음 오류
- `src/backend/media/videos/` 폴더에 영상 파일 확인
- 영상 파일명 형식: `{난이도}_{부위}_{운동종류}_{시간분}.mp4`

## 개발 참고사항

### 데이터베이스 스키마

#### 핵심 모델

**Sports** (운동 카테고리)
- 5가지 운동 종류 관리
- EmotionVideo, EmotionRecord, WorkoutSession과 연결
- 초기 데이터 자동 삽입됨

**EmotionVideo** (운동 영상)
- 24개의 운동 영상 메타데이터
- Sports와 자동 연결 (migration에서 처리)
- 난이도: 자세교정, 초급, 중급, 고급
- 부위: 전신, 목, 어깨, 목어깨, 등, 골반, 코어
- 초기 데이터 자동 삽입됨

**EmotionRecord** (감정 기록)
- 사용자별 일별 감정 기록
- 하루에 하나의 감정만 기록 가능 (`unique_together: user, date`)
- 감정, 강도(intensity), 메모, 태그, 운동 후 기분 등 저장
- 감정 이모지 및 한글 이름 자동 매핑

**WorkoutSession** (운동 세션)
- 운동 시작/종료 시간 기록
- Sports와 연결
- 운동 시간 자동 계산 (duration)

**PoseFrame** (자세 프레임)
- 실시간 포즈 좌표(keypoints) 저장
- AI 피드백(feedback) 자동 생성
- WorkoutSession과 연결

#### 고급 모델 (선택사항)

**ExpertPoseTemplate** (전문가 자세 템플릿)
- 표준 자세 템플릿 저장
- 운동별, 단계별 품질 레벨 관리
- 현재 미사용 (향후 확장 가능)

**FeedbackRating** (피드백 평가)
- 사용자의 AI 피드백 평가
- 피드백 정확도 개선에 활용
- 현재 미사용 (향후 확장 가능)

**MLModel** (머신러닝 모델)
- ML 모델 버전 관리
- 정확도, 정밀도, 재현율 등 성능 지표 저장
- 현재 미사용 (향후 확장 가능)

**Profile** (사용자 프로필)
- 운동 목표(main_goal), 루틴 시간(routine_time), 요일(routine_days)
- User와 1:1 관계
- 회원가입 시 자동 생성

## 라이선스

MIT License
