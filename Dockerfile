# Dockerfile

# 1. 베이스 이미지 선택 (Node.js 18 LTS)
FROM node:18-slim

# 2. 작업 디렉토리 설정
WORKDIR /app

# 3. 프로젝트 설정 파일 복사
COPY package*.json ./

# 4. 필요한 라이브러리 설치
RUN npm install

# 5. 소스 코드 전체 복사
COPY . .

# 6. 컨테이너 실행 시 웹 서버 시작
CMD [ "npm", "start" ]