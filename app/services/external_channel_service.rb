class ExternalChannelService
  attr_reader :adapter

  def initialize(channel_adapter)
    @adapter = channel_adapter
  end

  def batch_products(query)
    adapter.products(query)
  end

  def batch_orders(query)
    adapter.orders(query)
  end
end