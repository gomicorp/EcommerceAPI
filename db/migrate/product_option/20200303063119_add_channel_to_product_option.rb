class AddChannelToProductOption < ActiveRecord::Migration[6.0]
  def change
    add_reference :product_options, :channel, null: false
  end
end
