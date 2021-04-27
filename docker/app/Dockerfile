FROM ruby:2.6.3

RUN apt-get update -qq \
  && apt-get install -y build-essential

# Node.js 설치
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
  && apt-get install -y nodejs \
  && npm install -g yarn

# 컨테이너의 루트에 webapp 폴더 생성
RUN mkdir /app
WORKDIR /app

# host의 Gemfile, Gemfile.lock을 컨테이너에 복사
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock


# bundle install 실행
RUN gem update --system \
  && gem install bundler:1.17.3 \
  && bundler update --bundler


# host의 app 코드를 컨테이너에 복사
COPY . .

RUN yarn install --check-files

RUN mkdir -p tmp/pids

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

