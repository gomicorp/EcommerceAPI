module Gomisa
  module Zoho
    class Saver
      include ZohoRequest

      attr_reader :access_token
      attr_reader :res, :page

      def initialize(access_token)
        @access_token = access_token
        reset_context
      end

      def call
        while has_more_page?
          fetch && save(subjects)
        end
      end


      private

      def fetch; end
      def save(subjects); end

      def has_more_page?
        (@res || {}).dig('page_context', 'has_more_page')
      end

      def reset_context
        @res = {}
        @page = 0
      end
    end
  end
end
