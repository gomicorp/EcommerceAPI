module Shipping
  module UseAdapter
    module Collection
      def self.included(base)
        base.attr_reader :adapter
        base.attr_reader :base_url
      end


    end
  end
end