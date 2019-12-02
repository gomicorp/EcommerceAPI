class ChangeReferencesProductOptionToGroup < ActiveRecord::Migration[5.2]
  def change
    remove_reference :product_options, :product
    add_reference :product_options, :product_option_group, foreign_key: true
  end
end
