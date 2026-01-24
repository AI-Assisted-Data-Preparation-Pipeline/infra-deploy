# 🚀 Infra Deploy Guide

이 레포는 Orchestrator(Spring), AI Engine(FastAPI), MySQL을

Docker Compose 기반으로 배포하기 위한 인프라 구성 레포입니다.

---

## 📁 Directory Structure

```
infra-deploy/
├── docker-compose.yml
├── .env
├── .env.sample
├──deploy-dev.sh
├──deploy.sh
```

> orchestrator, ai-engine 레포는 infra-deploy와 같은 레벨에 위치해야 합니다.
> 

```
orchestrator/
ai-engine/
infra-deploy/
```

---

## ⚙️ Environment Variables

### 1️⃣ `.env.sample`

필수 환경변수 목록 정의용 파일입니다.

**실제 값은 넣지 않습니다.**

```
MYSQL_ROOT_PASSWORD=
MYSQL_DATABASE=
MYSQL_USER=
MYSQL_PASSWORD=

SPRING_PROFILES_ACTIVE=
DB_HOST=
DB_PORT=
DB_NAME=
DB_USERNAME=
DB_PASSWORD=
ORCH_PORT=

AI_ENGINE_BASE_URL=
OPENAI_API_KEY=
```

---

### 2️⃣ `.env`

실제 배포 환경 변수 파일입니다.

`.env.sample`에 정의된 **모든 키가 반드시 존재해야 합니다.**

```
MYSQL_PORT=3306
MYSQL_DATABASE=orchestrator
MYSQL_USER=orch_user
MYSQL_PASSWORD=secret

ORCH_PORT=8080
SPRING_PROFILES_ACTIVE=dev

...
```

> ⚠️ .env는 Git에 커밋하지 않습니다.
> 

---

### 🔍 환경변수 추가 시 절차

1. `.env.sample`에 **키 추가**
2. `.env`에 실제 값 추가
3. docker-compose.yml에서 사용
4. `deploy-*.sh` 실행

> .env.sample과 .env가 불일치하면 배포가 중단됩니다.
> 

---

## 🐳 Docker Compose

### 실행 서비스

- MySQL 8.0
- Orchestrator (Spring Boot)
- AI Engine (FastAPI)

### 네트워크

- docker-compose 내부 네트워크 사용
- AI Engine은 외부 포트 노출 없음
- 서비스 간 통신은 서비스명 기반

---

## 🚀 Deployment

### 개발 서버 배포

```bash
./deploy-dev.sh
```

- dev 브랜치 기준 pull
- docker compose build & up 실행
- 환경변수 누락 시 배포 중단

---

### 운영 서버 배포

```bash
./deploy.sh
```

- main 브랜치 기준 pull
- 운영 환경 배포

---

## 🧪 배포 스크립트 동작 순서

1. `.env`, `.env.sample` 존재 여부 확인
2. 필수 환경변수 누락 검증
3. orchestrator / ai-engine git pull
4. docker compose up -d --build 실행

---

## ⚠️ Notes

- MySQL charset, timezone은 docker-compose에서 설정됨
- 기존 MySQL 볼륨이 있으면 charset 변경이 적용되지 않을 수 있음
- 초기 개발 단계에서는 `docker compose down -v` 사용 가능

---

## ✅ 권장 운영 방식

- `dev` → 개발 서버
- `main` → 운영 서버
- CI 통과 후 PR merge
- 서버는 Pull 기반 배포

---