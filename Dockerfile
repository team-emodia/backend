# Python 3.11-slim을 기반 이미지로 사용
FROM python:3.11-slim

# 환경 변수 설정
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# 작업 디렉터리 설정
WORKDIR /app

# Poetry 설치
RUN pip install poetry

# 의존성 파일 복사 및 설치
COPY poetry.lock pyproject.toml /app/
RUN poetry config virtualenvs.create false && poetry install --no-dev --no-interaction --no-ansi

# 소스 코드를 컨테이너에 복사
COPY ./src/backend /app/src/backend

# 작업 디렉터리를 Django 프로젝트 디렉터리로 변경
WORKDIR /app/src/backend

# 8000번 포트 노출
EXPOSE 8000

# Uvicorn을 사용하여 애플리케이션 실행
CMD ["uvicorn", "testemo.asgi:application", "--host", "0.0.0.0", "--port", "8000"]
