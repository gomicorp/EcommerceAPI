#!/bin/sh

# docker-sync install
gem install docker-sync
docker-sync start

# direnv install
brew install direnv

# direnv가 설치되면 다음 코드를 ~/.zshrc에 추가해줍니다.
if [ -z "$(cat  ~/.zshrc | grep '# direnv setting')" ]
then
  echo "# direnv setting" >> ~/.zshrc
  echo "eval \"\$(direnv hook zsh)\"" >> ~/.zshrc
fi

# .envrc setting copy
echo "enter project ssh host name ex) store-api_prod: "
read ssh_host_name
echo ssh_host_name=${ssh_host_name} > ./.envrc
cat ./docker/.envrc >> ./.envrc

# container start
docker-compose up -d

# yarn_install
docker run --rm -v platform-api_codes:/app platform-api bash -c 'yarn install'

# container and sync start
direnv allow
echo complete!
