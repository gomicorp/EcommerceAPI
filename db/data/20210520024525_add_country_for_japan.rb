class AddCountryForJapan < ActiveRecord::Migration[6.0]
  def up
    Country.find_or_create_by(name: 'japan', name_ko: '일본', locale: 'ja', short_name: 'jp', iso_code: 'JPY')
    Country.find_by_name('korea').update(short_name: 'kr')
  end

  def down
    Country.find_by_name(name: 'japan').delete
    Country.find_by_name('korea').update(short_name: 'ko')
  end
end
