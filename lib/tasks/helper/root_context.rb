# frozen_string_literal: true

module Rake
  module Helper
    def root_context(&block)
      FileUtils.chdir APP_ROOT, &block
    end
    module_function :root_context
  end
end
