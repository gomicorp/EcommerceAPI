class AddCountryToBanners < ActiveRecord::Migration[6.0]
  def change
    add_reference :banners, :country, foreign_key: true
  end
end
