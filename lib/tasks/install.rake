# frozen_string_literal: true

require 'fileutils'
require_relative '../../vendor/tasks/helper'

namespace :install do
  desc 'Install all'
  task all: :environment do
    rake 'install:dotenv:all' if Rails.env.development?
  end


  namespace :dotenv do
    desc 'rails install:dotenv [create,database,port]'
    task all: :environment do
      rake 'install:dotenv:create', 'install:dotenv:database', 'install:dotenv:port'
    end

    desc 'Create .env file'
    task create: :environment do
      root_context do
        $stdout.puts "#{'Touch'.yellow} \t.env"
        FileUtils.touch '.env'
      end

      # config/application.rb 파일에 require('dotenv/load') 구문을 추가합니다.
      insert_line('config/application.rb', /Bundler\.require/, [
          '',
          "require 'dotenv/load'",
          ''
      ])

      add_ignore '.env'
    end

    desc "Put DATABASE_ENV > .env file"
    task database: :environment do
      env = Rails.application.credentials.dig(:database)
      host = "DATABASE_HOST=#{env[:host]}"
      username = "DATABASE_USERNAME=#{env[:username]}"
      password = "DATABASE_PASSWORD=#{env[:password]}"

      root_context do
        file = File.readlines('.env')
        File.open('.env', 'a') do |f|
          if file.grep(/DATABASE_HOST/i).empty? && file.grep(/DATABASE_USERNAME/i).empty? && file.grep(/DATABASE_PASSWORD/i).empty?
            f.puts
            f.puts "# 로컬 데이터베이스 설정입니다. 로컬 머신의 설정값과 다르다면, 알맞게 수정해서 사용하세요."
          end

          if file.grep(/DATABASE_HOST/i).empty?
            $stdout.puts "#{'Insert'.yellow} \t.env:insert \t#{host.yellow}"
            f.puts host
          end

          if file.grep(/DATABASE_USERNAME/i).empty?
            $stdout.puts "#{'Insert'.yellow} \t.env:insert \t#{username.yellow}"
            f.puts username
          end

          if file.grep(/DATABASE_PASSWORD/i).empty?
            $stdout.puts "#{'Insert'.yellow} \t.env:insert \t#{password.yellow}"
            f.puts password
          end
        end
      end
    end

    desc "Put PORT > .env file"
    task port: :environment do
      port_num = Rails.application.credentials.dig(:port)
      port = "PORT=#{port_num}"

      root_context do
        file = File.readlines('.env')
        File.open('.env', 'a') do |f|
          if file.grep(/PORT/i).empty?
            f.puts
            f.puts "# 서버 포트입니다."
            f.puts port
            $stdout.puts "#{'Insert'.yellow} \t.env:insert \t#{port.yellow}"
          end
        end
      end
    end
  end
end
