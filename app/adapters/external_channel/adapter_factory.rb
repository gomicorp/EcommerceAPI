module ExternalChannel
  class AdapterFactory
    class << self
      def known_adapter_map
        {
          haravan: HaravanAdapter,
          tiki: TikiAdapter,
          sendo: SendoAdapter,
          lazada: LazadaAdapter,
          shopee: ShopeeAdapter
        }
      end

      def adapter(channel_name)
        known_adapter_map[channel_name.to_s.downcase.to_sym].new || adapter_not_found!
      end

      def adapter_not_found!
        raise NotImplementedError, 'Requested Data Is Not Supported!'
      end
    end
  end
end
