module ActiveRecord
  class Imitation
    class << self
      def attributes
        @attributes ||= []
      end

      def attribute(key)
        attributes << key
      end

      attr_reader :adapter_name

      def adapter
        @adapter ||= adapter_name.to_s.constantize.new
      end

      def use_adapter(name)
        @adapter_name = name
      end
    end

    attr_reader :original_data

    # 직접 사용하지 않습니다.
    # Collection 객체가 데이터를 받아온 후
    # 데이터를 이 객체로 맵핑할 때에 사용합니다.
    def initialize(attributes = {})
      @original_data = (attributes || {}).symbolize_keys
      copy_to_member_variables permitted_data
    end

    def inspect
      attribute_list = attributes.dup.map do |var|
        name = var.to_s.gsub('@', '')
        value = send(name.to_sym)
        "#{name}: #{inspect_value_string(value)}"
      end
      "#<#{self.class.name} #{attribute_list.join(', ')}>"
    end

    def attributes
      permitted_attributes
    end

    private

    def permitted_data
      original_data.pick(*permitted_attributes)
    end

    def permitted_attributes
      registered_attrs = self.class.attributes
      registered_attrs.any? ? registered_attrs : original_data.keys
    end

    def copy_to_member_variables(hash)
      hash.each do |k, v|
        self.class.attr_accessor(k)
        send(:"#{k}=", v)
      end
    end

    def inspect_value_string(value)
      case value
      when Array, Integer, Float, BigDecimal
        value
      when NilClass
        'nil'
      else
        "\"#{value}\""
      end
    end
  end
end
