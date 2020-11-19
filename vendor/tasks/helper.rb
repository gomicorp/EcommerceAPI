# frozen_string_literal: true

require 'fileutils'
require_relative 'helper/constant'
require_relative 'helper/root_context'

module Rake
  ## Rake::Helper
  # Helper 모듈을 포함해 내부의 헬퍼 메소드들은 사실 Rails 에 컨벤션이
  # 있어서 작성된 것이 아니라 +순수 Ruby 메소드+ 입니다. 즉, Rake 나
  # Helper 모듈로 감싸지 않고 아래처럼 def 로만 정의해 사용해도 괜찮습니다.
  #
  #   # tasks/helper.rb
  #   def hi_task(name)
  #     puts "Hey #{name}"
  #   end
  #
  #   # tasks/db.rake
  #   require_relative 'helper'
  #   hi_task 'fred'
  #   => "Hey fred"
  #
  # 그러나 이 방법은 레일즈의 실행 프로세스라는 메모리 위에 어떤 함수를
  # 그대로 개방해 둔다는 점에서 이 함수를 전역화 시키는 것을 의미합니다.
  # 즉, 이 행위는 애플리케이션에서 예기치 않은 부작용을 초래할 것입니다.
  # 따라서 특정 목적의 유틸 기능을 수행하는 함수들을 보다 더 안전하게
  # 사용하고자 Rake::Helper#method 형태로 전환하고 격리하였습니다.
  module Helper
    # 모듈 안에서 desc, task 와 같은 키워드 함수들의 동작을 보장합니다.
    extend DSL

    # 기존에 정의되어 있는 기본 동작을 취소하고, 다른 동작을 실행하도록 내용을 덮어씁니다.
    #
    # Example:
    #   Rake::Helper.rake_alias 'db:migrate', 'db:schema:dump'
    #
    def rake_alias(old_task, new_task, &block)
      # 기존 동작 취소
      ::Rake::Task[old_task].clear

      # 동작 재정의
      desc "~> Aliased / Act as #{new_task}"
      task old_task.to_sym => :environment do
        puts "Aliased Rake Task / Act as \"#{new_task}\"".yellow

        # 실제 동작 실행
        ::Rake::Task[new_task].invoke

        block.call if block_given?
      end
    end
    module_function :rake_alias

    def exec(*args)
      ppp(output: :puts) { 'Invoke'.cyan + "\t#{args}".blue }
      system(*args) || abort("\n== Command #{args} failed ==")
    end
    module_function :exec

    def run(name)
      ppp(output: :puts) { 'Invoke'.cyan + "\tRails #{name}".blue }
      ::Rake::Task[name.to_sym].invoke
    rescue RuntimeError
      run_command name
    end
    module_function :run

    def run_command(name)
      ppp(output: :puts) { 'Command'.cyan + "\tRails #{name}".blue }
      ::Rails::Command.invoke name.to_s
    end
    module_function :run_command

    def pipe(*tasks)
      tasks.each do |t|
        run t
      end
    end
    module_function :pipe
  end
end

require_relative 'helper/file_handler'
require_relative 'helper/improve_dsl'

self.extend Rake::Helper::ImproveDSL
