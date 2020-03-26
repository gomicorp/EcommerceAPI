class AddChannelCodeToProductOption < ActiveRecord::Migration[6.0]
  def change
    add_column :product_options, :channel_code, :string
  end
end
