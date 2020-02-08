# Docker로 개발, 배포하기

***rvm싸미 듕귁에 달아 문짜와로 서르사맛디 아니할쎼
내 이런 젼차로 어린 뷕셩이 환장 하노라
내 이를 위하야 어엿비너겨 새로 docker process 맹가노니
해야 수비니겨 날로 쑤매 뻔한킈 하고져 할 따라미니라***

## 1. 개발환경 구축하기
#### 1. 프로젝트를 clone 받아 주시고 master.key, .env를 설정해주세요. 
```bash
git clone https://github.com/gomicorporation/platform-api.git
```
.env 파일의 db 설정은 다음과 같이 해줍시다!
```bash
DATABASE_USERNAME=<여러분의 DATABASE_USERNAME>
DATABASE_PASSWORD=<여러분의 DATABASE_PASSWORD>
DATABASE_HOST=docker.for.mac.localhost
```

#### 2. 프로젝트의 docker폴더에 있는 스크립트를 실행하여 개발환경 구축을 진행하시면 됩니다. 
```bash
bash ./docker/mac_init.sh
```
<br/>

## 2. 개발환경 시작하기
먼저 우리가 개발을 진행할 도커 컨테이너를 켜줍니다.
```bash
dev_start
```

컨테이너가 켜지면 다음 명령어로 docker container의 shell로 진입한후 필요한 명령어를 입력하여 개발을 진행하시면 됩니다.
```bash
shell
```

shell 명령어를 이용하여 개발을 진행할수 있지만 편의를 위해 shortcut들을 만들었습니다.
rails s, rails c, rails console --sandbox를 사용할때는 다음과 같이 사용할수 있습니다.
```bash
# rails s
railss

# rails c
console

# rails console --sandbox
sandbox
```

오늘의 개발이 끝나면 다음 명령어로 컨테이너와 docker-sync를 종료해주면 됩니다.
(굳이 안해도 되지만 컨테이너가 계속 켜져있게 됩니다.)
```bash
dev_stop
```

## 3. 새로운 이미지 배포하기 
프로젝트 루트 디렉토리에서 다음 명령어를 입력하여 새로운 이미지를 빌드합니다.
```bash
prod_image_build
```

프로젝트 루트 디렉토리에서 다음 명령어를 입력하여 docker hub에 push 한후 배포를 진행할수 있습니다.
```bash
### staging 배포시 이렇게 합니다. ###
staging_deploy

### production 배포시 이렇게 합니다. ###
production_production_deploy
```
