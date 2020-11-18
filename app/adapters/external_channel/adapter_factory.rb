module ExternalChannel
  class AdapterFactory
    def self.get_adapter(channel_name)
      case channel_name.downcase
      when 'haravan'
        ExternalChannel::HaravanAdapter.new
      when 'tiki'
        ExternalChannel::TikiAdapter.new
      when 'sendo'
        ExternalChannel::SendoAdapter.new
      when 'lazada'
        ExternalChannel::LazadaAdapter.new
      when 'shopee'
        ExternalChannel::ShopeeAdapter.new
      else
        raise NotImplementedError, 'Requested Data Is Not Supported!'
      end
    end
  end
end
