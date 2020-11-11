module ExternalChannel
  class AdapterFactory
    def initialize(channel_name)
      case channel_name
      when 'Haravan'
        ExternalChannel::HaravanAdapter.new
      when 'Tiki'
        ExternalChannel::TikiAdapter.new
      when 'Sendo'
        ExternalChannel::SendoAdapter.new
      when 'Lazada'
        ExternalChannel::LazadaAdapter.new
      when 'Shopee'
        ExternalChannel::ShopeeAdapter.new
      else
        raise NotImplementedError('Requested Data Is Not Supported!')
      end
    end
  end
end