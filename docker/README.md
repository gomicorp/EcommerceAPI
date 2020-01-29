# Docker로 개발, 배포하기

***rvm싸미 듕귁에 달아 문짜와로 서르사맛디 아니할쎼
내 이런 젼차로 어린 뷕셩이 환장 하노라
내 이를 위하야 어엿비너겨 새로 docker process 맹가노니
해야 수비니겨 날로 쑤매 뻔한킈 하고져 할 따라미니라***

## 1. 개발환경 구축하기
#### 1. 빠른 개발을 위한 docker-sync gem을 설치해주세요
```bash
gem install docker-sync
```

#### 2. 편리한 개발을 위한 direnv을 설치해주세요
```bash
brew install direnv

# direnv가 설치되면 다음 코드를 ~/.zshrc에 추가해줍니다.
eval "$(direnv hook zsh)"
```

#### 3. 프로젝트를 clone 받아 주세요
```bash
git clone https://github.com/gomicorporation/platform-api.git
```

#### 3.3. 프로젝트의 docker 폴더에 위치한 .envrc 파일을 프로젝트 루트폴더로 복사해주세요
```bash
cp ./docker/.envrc ./
```
요
#### 3.5. 프로젝트 루트 폴더로 복한 .envrc 첫째줄의 ssh_host_name을 본인의 ssh_host_name으로 변경해주세요 (ex: store_api, store, store_th ...)
```bash
#변경전사
ssh_host_name=test-dockerize-store-api

#변경후 
ssh_host_name=store_th
```

#### 4. 프로젝트 폴더로 이동하여 다음 명령어를 입력해주십시다
```bash
direnv allow
```

#### 5. master.key, .env 파일을 세팅해 주십시다. 특히 .env 파일의 db 설정은 다음과 같이 해줍시다!
```bash
DATABASE_USERNAME=<여러분의 DATABASE_USERNAME>
DATABASE_PASSWORD=<여러분의 DATABASE_PASSWORD>
DATABASE_HOST=docker.for.mac.localhost
```

#### 6. 개발용 이미지를 빌드해주고 node_modules 을 깔아줍시다.
```bash
image_init
yarn_install
```
<br/>

## 2. 개발환경 시작하기
다음 명령어로 개발환경을 시작할수 있습니다. 실행후 control + c를 누르면 개발환경이 종료됩니다.
```bash
dev_start
```

만약 rails db:migrate, rails console --sandbox, gem install xxx 와같은 rails나 ruby
관련 명령어가 쓰고 싶다면 다음 명령어로 docker container로 진입한후 사용하시면 됩니다.
```bash
docker_shell
```

## 3. 새로운 이미지 배포하기 
다음 명령어를 입력하여 새로운 이미지를 빌드합니다.
```bash
prod_image_build
```

다음 명령어를 입력하여 docker hub에 push 한후 배포를 진행할수 있습니다.
```bash
### staging 배포시 이렇게 합니다. ###
staging_deploy

### production 배포시 이렇게 합니다. ###
production_production_deploy
```
