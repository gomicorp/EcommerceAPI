module ExternalChannel
  class ExternalChannelService
    attr_reader :adapter, :products

    def initialize(channel_adapter)
      @adapter = channel_adapter
    end

    def batch_products
      return false unless is_valid_adapter?

      @products = adapter.products
    end

    def batch_orders

    end

    private

    def is_valid_adapter?
      adapter.instance_of? ExternalChannelAdapter
    end

    def is_valid_products?
      ExternalChannel.validate_products(products)
    end
  end
end