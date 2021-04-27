#개발환경 이미지 빌드 명령어
docker build -t platform-api .

#배포환경 이미지 빌드 명령어
docker build -t gomicorp/platform-api:latest -f ./docker/Dockerfile ./

#개발환경 실행 명령어
docker-compose up

#개발환경 종료 명령어
docker-compose stop

# 일회용 컨테이너를 실행하는 예제
docker run --rm -it gomicorp/platform-api:latest /bin/bash
