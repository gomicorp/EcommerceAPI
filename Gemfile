source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# gem 'haravan_api', git: 'https://github.com/Haravan/haravan_api.git'
gem 'lazop_api_client', git: 'https://github.com/kfit-dev/lazop-api-client'

gem 'yajl-ruby', require: 'yajl'
gem 'data_migrate'

## => Store Service
gem 'sentry-raven'
gem 'slack-notifier'

## => Store Office
gem 'pagy'
gem 'rails_admin', '~> 2.0', git: 'https://github.com/sferik/rails_admin.git'
gem 'schema_to_scaffold'

## => Common
gem 'http_accept_language'
gem 'locale_router', git: 'https://github.com/yhk1038/locale_router.git'
gem 'omise'
gem 'iamport'
gem 'rack-cors'
gem 'rails-file_storage', git: 'https://github.com/yhk1038/file_storage.git'
gem 'ransack'
gem 'will_paginate'

# 회원인증 및 권한설정을 위한 젬
gem 'authority' # 권한설정
gem 'devise', github: 'heartcombo/devise', branch: 'ca-omniauth-2'
gem 'devise-jwt' # jwt 사용
gem 'jwt'
gem 'letter_opener', group: :development # 개발 모드에서 이메일을 보내지 않고 브라우저에서 미리보기하는 젬
gem 'mailgun-ruby'
gem 'omniauth-facebook' # 페이스북 로그인
gem 'rolify' # role 관리

gem 'active_link_to'
gem 'awesome_print'
gem 'aws-sdk-s3', require: false
gem 'dotenv-rails'
gem 'kaminari'
gem 'rb-readline'
gem 'rubocop', require: false
gem 'rubocop-performance'
gem 'seed_dump'
gem 'simple_trans', git: 'https://github.com/yhk1038/simple_trans.git'
gem 'paper_trail'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '6.0.3'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.4.4'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
gem 'jbuilder-except'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :didimdol, :test do
# = 배치 프로세스 진행 시, 웹 인증 과정 자동화를 위한 젬
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'faker'
  gem 'annotate'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# sprocket version downgrade
gem 'sprockets', '3.7.2'
