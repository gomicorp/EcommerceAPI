class ChangeTypeOfTitleForJsonToProducts < ActiveRecord::Migration[6.0]
  def up
    change_column :products, :title, :json
    add_column :products, :title_en, :string, as: "JSON_UNQUOTE(JSON_EXTRACT(title, '$.en'))", stored: true
    add_column :products, :title_th, :string, as: "JSON_UNQUOTE(JSON_EXTRACT(title, '$.th'))", stored: true
    add_column :products, :title_ko, :string, as: "JSON_UNQUOTE(JSON_EXTRACT(title, '$.ko'))", stored: true
  end

  def down
    remove_column :products, :title_en, :string
    remove_column :products, :title_th, :string
    remove_column :products, :title_ko, :string
  end
end
