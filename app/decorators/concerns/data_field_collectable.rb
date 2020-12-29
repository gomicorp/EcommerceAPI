module DataFieldCollectable
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def data_fields
      @data_fields ||= {}
    end

    def data_keys_from_model(model_name = nil, option = {})
      decorates model_name if !object_class? && model_name

      unless object_class
        raise 'object_class 를 인식하지 못했습니다. ' \
            '`decorates :company` 와 같이 object_class 를 선언해주세요.'
      end

      permitted_model_attributes(
        option.dig(:only),
        option.dig(:except)
      ).each do |attr_name|
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


    private

    def add_data_fields(data_field)
      data_fields[data_field.name] = data_field
    end

    def permitted_model_attributes(permit_filters, deny_filters)
      attributes = object_class.attribute_names.map(&:to_sym)

      attributes &= permit_filters if permit_filters.is_a? Array
      attributes -= deny_filters if deny_filters.is_a? Array

      attributes
    end
  end


  def as_json(options = nil)
    fields = self.class.data_fields.values

    # 별도로 data_key 를 통해 선언된 필드가 없는 경우, 기본 as_json 동작을 수행 합니다.
    return super if fields.empty?

    fields.map { |data_field| data_field.to_data(self) }.to_h
  end


  class DataField
    attr_reader :name, :option, :method

    def initialize(name, option = {}, &block)
      @name = name
      @option = option
      @method = block if block_given?
    end

    def to_data(record)
      [name, value_for(record)]
    end

    def value_for(record)
      if method&.is_a?(Proc)
        method.call(record, self, name)
      else
        record.send(name)
      end
    end
  end
end
