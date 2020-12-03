module ExternalChannel
  class ManagerFactory
    class << self
      def known_manager_map
        {
          product: Product::Manager,
          order: Order::Manager
        }
      end

      def manager(data_type, adapter)
        known_manager_map[data_type.to_s.downcase.to_sym].new(adapter) || adapter_not_found!
      end

      def manager_not_found!
        raise NotImplementedError, 'Requested Data Is Not Supported!'
      end
    end
  end
end
