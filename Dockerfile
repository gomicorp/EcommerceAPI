FROM gomicorp/rails:6.0.2.1

#gem 설치
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem && rm -rf Gemfile Gemfile.lock
