class ProductOption < ApplicationRecord
  belongs_to :option_group, class_name: 'ProductOptionGroup', dependent: :destroy, foreign_key: :product_option_group_id
  has_many :barcode_options
  has_many :barcodes, through: :barcode_options

  has_many :product_option_bridges
  has_many :items, :through => :product_option_bridges, :source => :connectable, :source_type => 'ProductItem'
  has_many :collections, :through => :product_option_bridges, :source => :connectable, :source_type => 'ProductCollection'
  has_many :product_item_barcodes, through: :items

  delegate :product, to: :option_group
  def title
    "#{option_group.name}: #{name}"
  end

  def base_price
    @base_price ||= items.sum(:selling_price) #product.price + additional_price
  end

  def retail_price
    @retail_price ||= base_price + price_change
  end

  # connectables getter
  def connectables
    items + collections
  end

  # connectables setter
  def connectables=(connectable_list)
    new_items = []
    new_collections = []

    connectable_list.each do |connectable|
      if connectable.class == ProductItem
        new_items.append(connectable)
      else
        new_collections.append(connectable)
      end
    end

    items << new_items
    collections << new_collections
  end

  # TODO: 할인/추가 금액 관련. 리펙토링 필요.
  def price_change
    @price_change = 0
    case discount_type
    when 'const'
      @price_change -= discount_amount
    when 'ratio'
      @price_change -= (base_price * discount_amount)
    end
    @price_change
  end
end
