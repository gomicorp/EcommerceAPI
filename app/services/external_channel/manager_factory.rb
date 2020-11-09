module ExternalChannel
  class ManagerFactory
    def self.initialize(data_type, adapter)
      case data_type
      when 'product'
        ExternalChannel::Product::Manager.new(adapter)
      when 'order'
        ExternalChannel::Order::Manager.new(adapter)
      else
        raise NotImplementedError("The Requested Data Type #{data_type} is not Implemented.")
      end
    end
  end
end