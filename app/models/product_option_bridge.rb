### Calculate ProductOptionBridge
#
## ===== source columns ======
#
## ===== calculated columns ======
# :selling_price
#
class ProductOptionBridge < ApplicationRecord
  belongs_to :connectable, polymorphic: true
  belongs_to :product_option

  JOIN_CONNECTABLE_QUERY = lambda do |klass|
    resource_key = 'connectable'
    klass = klass.to_s.constantize if klass.is_a?(String) || klass.is_a?(Symbol)
    resource_id, resource_type = "#{resource_key}_id", "#{resource_key}_type"
    "LEFT JOIN #{klass.table_name} ON #{klass.table_name}.id = #{table_name}.#{resource_id} AND #{table_name}.#{resource_type} = \"#{klass.name}\""
  end

  delegate :alive_barcodes_count, to: :connectable

  scope :item_with, ->(product_item) { where(connectable: product_item).or(where(connectable: ProductCollection.item_with(product_item))) }
  scope :option_with, ->(*option_ids) { where(product_option_id: option_ids) }
  scope :connectables, -> { group(:connectable_type, :connectable_id).count.keys.map { |con| Object.const_get(con.first).find con.second } }
  scope :joins_connectable, lambda {
    get_sql = JOIN_CONNECTABLE_QUERY
    joins(get_sql.call(ProductItem)).joins(get_sql.call(ProductCollection))
  }

  after_save :after_save_propagation

  def active
    connectable.active
  end

  alias active? active

  def unit_count
    connectable&.unit_count
  end

  def available_quantity
    connectable.available_quantity
  end

  def items
    case connectable_type
    when 'ProductItem'
      ProductItem.where(id: connectable_id)
    when 'ProductCollection'
      connectable.items
    end
  end


  ## ===== before calculator =====

  # def selling_price
  #   connectable&.selling_price.to_i
  # end
  # alias price selling_price


  ## ===== Calculators =====

  def calc_selling_price
    connectable&.selling_price.to_i
  end


  def calculate_price_columns
    self.selling_price = calc_selling_price

    print_columns :selling_price
  end

  private
  ## ===== ActiveRecord Callbacks =====

  def after_save_propagation
    product_option.tap do |option|
      option.calculate_price_columns
      option.save
    end
  end
end
