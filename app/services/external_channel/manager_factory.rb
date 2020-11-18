module ExternalChannel
  class ManagerFactory
    def self.get_manager(data_type, adapter)
      case data_type
      when 'product'
        Product::Manager.new(adapter)
      when 'order'
        Order::Manager.new(adapter)
      else
        raise NotImplementedError, "The Requested Data Type #{data_type} is not Implemented."
      end
    end
  end
end
