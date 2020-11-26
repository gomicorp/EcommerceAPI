module ExternalChannel
  class AdapterFactory
    def self.get_adapter(channel_name)
      case channel_name.downcase
      when 'haravan'
        HaravanAdapter.new
      when 'tiki'
        TikiAdapter.new
      when 'sendo'
        SendoAdapter.new
      when 'lazada'
        LazadaAdapter.new
      when 'shopee'
        ShopeeAdapter.new
      else
        raise NotImplementedError, 'Requested Data Is Not Supported!'
      end
    end
  end
end
