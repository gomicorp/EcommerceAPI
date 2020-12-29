class ApplicationDecorator < Draper::Decorator
  # decorates_finders

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def as_json(options = nil)
    fields = self.class.data_fields

    # 별도로 data_key 를 통해 선언된 필드가 없는 경우, 기본 as_json 동작을 수행 합니다.
    return super if fields.empty?

    hash = {}
    fields.each do |data_field|
      k ,v = data_field.to_data(self)
      hash[k] = v
    end

    hash
  end

  def self.data_fields
    @data_fields ||= []
  end

  def self.add_data_fields(data_field)
    data_fields << data_field
  end

  # TODO: 메소드 이름이 안예뻐요....
  def self.data_keys_from_attribute
    unless object_class
      raise 'object_class 를 인식하지 못했습니다. ' \
            '`decorates :company` 와 같이 object_class 를 선언해주세요.'
    end

    object_class.attribute_names.each do |attr_name|
      add_data_fields DataField.new(attr_name.to_s.to_sym)
    end
  end

  def self.data_key(name, option = {}, &block)
    add_data_fields DataField.new(name, option, &block)
  end

  class DataField
    attr_reader :name, :option, :method

    def initialize(name, option = {}, &block)
      @name = name
      @option = option

      if block_given?
        @method = block
      end
    end

    def to_data(record)
      key = @name
      value = if method
                method.call(record, self, @name)
              else
                record.send(@name)
              end

      [key, value]
    end

    # def parse_value
    #
    # end
  end
end
