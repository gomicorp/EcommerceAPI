class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  extend AutoIncrement
  extend ParseCountryCode
  include TimeMachine::Concern

  def cls
    self.class
  end

  def self.extend_has_one_attached(name)
    has_one_attached name.to_sym
    scope "#{name}_attached".to_sym, -> { left_joins("#{name}_attachment".to_sym).where('active_storage_attachments.id is NOT NULL') }
    scope "#{name}_unattached".to_sym, -> { left_joins("#{name}_attachment".to_sym).where('active_storage_attachments.id is NULL') }
  end

  def self.extend_has_many_attached(name)
    has_many_attached name.to_sym
    scope "#{name}_attached".to_sym, -> { left_joins("#{name}_attachments".to_sym).where('active_storage_attachments.id is NOT NULL') }
    scope "#{name}_unattached".to_sym, -> { left_joins("#{name}_attachments".to_sym).where('active_storage_attachments.id is NULL') }
  end

  def self.associations
    reflect_on_all_associations.map do |reflect|
      {klass: reflect.klass, name: reflect.name, options: reflect.options}
    end
  end

  def self.association_names
    associations.pluck(:name)
  end

  def associations
    self.class.associations
  end

  def association_names
    self.class.association_names
  end

  private

  # => 객체가 가진 속성을 선택적으로 출력하는 것을 도와줍니다.
  #
  # 만약 다음과 같이 실행시키면 (실제로는 private 메소드 입니다)
  # >   product_option.print_columns(:base_price, :discount_price, :price_change, :retail_price)
  #
  # 다음과 같이 콘솔에 출력합니다.
  # >   ProductOption.find(1) { base_price: 200, discount_price: 0, price_change: 0, retail_price: 200 }
  #
  def print_columns(*columns)
    indent_size = 5
    indent = ' ' * indent_size
    puts indent + "#{self.class.name}.find(#{id}) { #{columns.map { |column_name| "#{column_name}: #{send(column_name.to_sym)}" }.join(', ')} }"
  end

  def self.line_cover(indent: 3, line_length: 50)
    name_str = " #{name + ' ' * (name.length % 2)} "
    wing_size = (line_length - name_str.length) / 2
    wing = '-' * wing_size

    border_top = wing + name_str + wing
    border_bottom = '-'*border_top.length

    puts "\n"
    puts((' '*indent) + border_top + "\n\n")
    res = yield
    puts("\n" +(' '*indent) + border_bottom)
    puts "\n\n"
    res
  end

  # 각 모델 클래스에서, 자신의 관계 모델에 대하여 좀비레코드 가능을 명시적으로 주입합니다.
  def self.zombie(name)
    target_association = self.associations[self.association_names.index(name)]
    method_name = "zombie_#{name}"
    variable = "#{method_name}"

    class_eval <<-METHOD, __FILE__, __LINE__ + 1
      def #{method_name}
        return @#{variable} if @#{variable}

        @#{variable} = self.#{name}
        unless @#{variable}
          last_version = PaperTrail::Version.where(item_id: #{name}_id, item_type: '#{target_association[:klass].name}').last
          @#{variable} = last_version.reify if last_version && last_version.event == 'destroy'
        end
        @#{variable}
      end
    METHOD
  end

  # Zombie Query Method (삭제한 놈도 찾아드림)
  def self.zombie_find(id)
    find(id)
  rescue ActiveRecord::RecordNotFound => e
    record = nil
    last_version = PaperTrail::Version.where(item_id: id, item_type: name).last
    record = last_version.reify if last_version && last_version.event == 'destroy'

    return record if record

    raise e
  end
end
