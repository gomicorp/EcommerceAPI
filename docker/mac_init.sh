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
echo "please enter project ssh host name! ex) store-api_prod: "
read ssh_host_name
echo ssh_host_name=${ssh_host_name} > ./.envrc
cat ./docker/.envrc >> ./.envrc

# container start
docker-compose up -d

# bundle_install
rm Gemfile.lock
docker exec platform-api-web bash -c 'bundle install'

# yarn_install
docker exec platform-api-web bash -c 'yarn install'

# direnv allow
sh -c 'direnv allow'

# sync, container stop
docker-compose stop
docker-sync stop

# local mysql setting
source .env
mysql -u${DATABASE_USERNAME} -p${DATABASE_PASSWORD} -Bse \
"ALTER USER ${DATABASE_USERNAME}@localhost IDENTIFIED WITH mysql_native_password BY \"${DATABASE_PASSWORD}\";"

echo complete!
