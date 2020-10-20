class AddSpecialPageAndSideMenuItemSeed < ActiveRecord::Migration[6.0]
  def up
    company = Company.first_or_create(name: '하하')
    Country.all.each do |country|
      ['오렌지게이트', '코트라 수출관', '고미 PB 상품관'].each.with_index do |page_title, j|
        page = Store::SpecialPage.create(title: page_title, country: country)

        5.times do |i|
          idx = "#{j}#{i}"
          brand = Brand.create(
              name: {ko: "아에이오우 #{country.short_name} #{idx}", en: "AEIOU #{idx}", th: "AEIOU #{idx}", vi: "AEIOU #{idx}"},
              company: company,
              country: country
          )

          page.side_menu_items.create(name: "아에이오우 #{idx}", connectable: brand)
        end
      end
    end
  end

  def down
    # raise ActiveRecord::IrreversibleMigration
  end
end
