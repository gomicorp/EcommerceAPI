# frozen_string_literal: true

require 'forwardable'

module Rake
  module Helper
    module ImproveDSL
      extend Forwardable
      def_delegators :'::Rake::Helper', :root_context, :run, :pipe
      def_delegators :'::Rake::Helper', :add_ignore, :insert_line

      def rake(*names)
        names.any? ? pipe(*names) : MethodChain.new
      end


      class MethodChain
        extend Forwardable
        def_delegators :'::Rake::Helper', :exec, :rake_alias

        def alias(old_task, new_task, &block)
          rake_alias(old_task, new_task, &block)
        end
      end
    end
  end
end
