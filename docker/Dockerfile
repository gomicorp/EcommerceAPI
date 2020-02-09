#### 배포용 이미지 빌드 ####
FROM gomicorp/rails-with_passenger:6.0.2.1
WORKDIR /app

#gem 설치 및 logrotate 설치
COPY Gemfile ./
RUN bundle install --without 'development test' && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

# 비즈니스 로직 복사, 로그 설정 및 nginx 설정 복사
COPY . .
RUN rm -rf Gemfile.lock && bundle config set without 'development test' && bundle install && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem \
    && yarn install && yarn cache clean \
    && SECRET_KEY_BASE=1 APP_FORCE_ENV=development RAILS_ENV=production rails assets:precompile \
    && cp ./docker/logrotate/api ./docker/logrotate/serverlog /etc/logrotate.d \
    && rm -rf /app/tmp && mkdir /app/tmp && touch /app/tmp/.keep && chmod o+w /app/tmp
