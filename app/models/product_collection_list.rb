# == Schema Information
#
# Table name: product_collection_lists
#
#  item_id       :bigint           not null, primary key
#  collection_id :bigint           not null
#  unit_count    :bigint           default(0), not null
#
class ProductCollectionList < ApplicationRecord
  self.primary_key = :item_id

  belongs_to :collection, class_name: 'ProductCollection'
  belongs_to :item, class_name: 'ProductItem'

  def save(*_arg, **_opt)
    return false unless can_update?

    update_unit_count_if_have_to
  end

  def can_update?
    !collection.active?
  end

  attribute :_custom_destroy

  def _custom_destroy
    marked_for_destruction?
  end

  def custom_destroy
    self.unit_count = 0
    save
  end

  def available_quantity
    item.alive_barcodes_count / unit_count
  end

  def cost_price
    item.cost_price * unit_count
  end

  def selling_price
    item.selling_price * unit_count
  end


  private

  def update_unit_count_if_have_to
    diff = count_to_change_unit_count
    return true if diff.zero?

    # raise
    add_elements(diff) if diff.positive?
    remove_elements(diff.abs) if diff.negative?
    true
  end

  def count_to_change_unit_count
    original_unit_count = collection.lists.find_or_initialize_by(item_id: item_id).unit_count
    unit_count - original_unit_count
  end

  def add_elements(count)
    collection.elements.create elements_to_create count
  end

  def remove_elements(count)
    collection.elements.destroy elements_to_destroy count
  end

  def elements_to_create(count)
    [{ product_item_id: item_id }] * count
  end

  def elements_to_destroy(count)
    collection.elements.where(product_item_id: item_id).order(id: :desc).limit(count)
  end
end
