module DataFieldCollectable
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def data_fields
      @data_fields ||= []
    end

    # TODO: 메소드 이름이 안예뻐요....
    def data_keys_from_attribute
      unless object_class
        raise 'object_class 를 인식하지 못했습니다. ' \
            '`decorates :company` 와 같이 object_class 를 선언해주세요.'
      end

      object_class.attribute_names.each do |attr_name|
        add_data_fields DataField.new(attr_name.to_s.to_sym)
      end
    end

    def data_key(name, option = {}, &block)
      association_option = option.slice(:with, :scope, :context)
      decorates_association name, **association_option if association_option.any?

      add_data_fields DataField.new(name, option, &block)
    end

    # 여러개의 키를 한 번에 넣을 때 사용할 수 있습니다.
    #
    # ===
    #   data_keys :id, :name, ...
    #
    #   data_keys *Company.attribute_names
    def data_keys(*names, **option)
      names.each { |name| data_key name, option }
    end

    def add_data_fields(data_field)
      data_fields << data_field
    end
  end


  def as_json(options = nil)
    fields = self.class.data_fields

    # 별도로 data_key 를 통해 선언된 필드가 없는 경우, 기본 as_json 동작을 수행 합니다.
    return super if fields.empty?

    hash = {}
    fields.each do |data_field|
      k, v = data_field.to_data(self)
      hash[k] = v
    end

    hash
  end


  class DataField
    attr_reader :name, :option, :method

    def initialize(name, option = {}, &block)
      @name = name
      @option = option
      @method = block if block_given?
    end

    def to_data(record)
      key = @name
      value = if method&.is_a?(Proc)
                method.call(record, self, @name)
              else
                record.send(@name)
              end

      [key, value]
    end
  end
end
