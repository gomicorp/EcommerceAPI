#### 스테이징용 이미지 빌드 ####
# 추후 staging service 이미지로 배포 가능
FROM gomicorp/rails-with_passenger:6.0.3 as staging

WORKDIR /app

#소스코드 복사
RUN git clone https://github.com/gomicorp/EcommerceAPI.git -b develop /app \
    && git checkout develop && git clean -fd && git reset --hard

# gem 설치 및 logrotate 설치
RUN rm -rf Gemfile.lock && bundle config set without 'development test' && bundle install && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem \
    && yarn install && yarn cache clean \
    && rm -rf /app/tmp && mkdir /app/tmp && touch /app/tmp/.keep && chmod o+w /app/tmp


#### 프로덕션용 이미지 빌드 ####
# 추후 production service 이미지로 배포 가능
FROM gomicorp/rails-with_passenger:6.0.3 as production

WORKDIR /app

#소스코드 복사
RUN git clone https://github.com/gomicorp/EcommerceAPI.git -b master /app \
    && git checkout master && git clean -fd && git reset --hard

# gem 설치 및 logrotate 설치
RUN rm -rf Gemfile.lock && bundle config set without 'development test' && bundle install && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem \
    && yarn install && yarn cache clean \
    && rm -rf /app/tmp && mkdir /app/tmp && touch /app/tmp/.keep && chmod o+w /app/tmp
