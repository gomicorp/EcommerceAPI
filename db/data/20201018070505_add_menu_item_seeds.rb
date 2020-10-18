class AddMenuItemSeeds < ActiveRecord::Migration[6.0]
  def up
    Store::Gnb::MenuItem.create(
        country: Country.th,
        name: { ko: '브랜드관', en: 'Brands', th: 'Brands', vi: 'Brands' },
    )
  end

  def down
    # raise ActiveRecord::IrreversibleMigration
  end
end
