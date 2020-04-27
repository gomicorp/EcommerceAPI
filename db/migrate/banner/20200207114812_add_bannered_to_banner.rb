class AddBanneredToBanner < ActiveRecord::Migration[6.0]
  def change
    add_reference :banners, :bannered, polymorphic: true, index: true
  end
end
