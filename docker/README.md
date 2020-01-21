# Docker로 개발, 배포하기

***docker로 세상을 이롭게 하겠다***

## 1. 개발환경 구축하기
#### 1. 빠른 개발을 위한 docker-sync gem을 설치해주세요
```bash
gem install docker-sync
```
<br/>

#### 2. 편리한 개발을 위한 direnv을 설치해주세요
```bash
brew install direnv

# direnv가 설치되면 다음 코드를 ~/.zshrc에 추가해줍니다.
eval "$(direnv hook zsh)"
```
<br/>

#### 3. 프로젝트를 clone 받아 주세요
```bash
git clone https://github.com/gomicorporation/platform-api.git
```
<br/>

#### 4. 프로젝트 폴더로 이동하여 다음 명령어를 입력해주십시다
```bash
direnv allow
```
<br/>

#### 5. master.key, .env 파일을 세팅해 주십시다. 특히 .env 파일의 db 설정은 다음과 같이 해줍시다!
```bash
DATABASE_USERNAME=<여러분의 DATABASE_USERNAME>
DATABASE_PASSWORD=<여러분의 DATABASE_PASSWORD>
DATABASE_HOST=docker.for.mac.localhost
```
<br/>

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
<br/>

만약 rails db:migrate, rails console --sandbox, gem install xxx 와같은 rails나 ruby
관련 명령어가 쓰고 싶다면 다음 명령어로 docker container로 진입한후 사용하시면 됩니다.
```bash
docker_shell
```
## 3. 새로운 이미지 배포하기 
docker_shell을 활용하여 asset compile을 진행해주신다
다음 명령어를 입력하여 새로운 이미지를 빌드하고 docker hub에 푸시해줍니다.
```bash
prod_image_build
음
docker push gomicorp/platform-api
```
<br/>

docker hub에 push가 완료되면 ec2환경으로 이동하여 새로운 이미지를 pull을 받아주고 
staging 혹은 production에 배포를 진행하시면 됩니다.
```bash
docker pull gomicorp/platform-api

### staging 배포시 이렇게 합니다. ###
cd ~/platform-api/staging 
docker-compose -f start.yml down 
docker-compose -f start.yml up -d

### production 배포시 이렇게 합니다. ###
cd ~/platform-api/production
docker-compose -f start.yml down 
docker-compose -f start.yml up -d
```

그리고 필요하지 않은 이미지를 정리해주면 배포가 끝나게 됩니다.
```bash
docker system prune --volumes
```
