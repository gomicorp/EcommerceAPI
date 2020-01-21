# Docker로 개발, 배포하기

***docker로 세상을 이롭게 하겠다***

## 1. 개발환경 구축하기
#### 1. 먼저 docker-sync gem을 설치해주세요
```bash
gem install docker-sync
```
#### 2. 편리한 개발을 위한 direnv을 설치해주세요
```bash
brew install direnv

# direnv가 설치되면 다음 코를 ~/.zshrc에 추가해줍니다.
eval "$(direnv hook zsh)"
```

#### 3. 프로젝트를 clone 받아 주세요
```bash
git clone https://github.com/gomicorporation/platform-api.git
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
