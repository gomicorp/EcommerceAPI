class AddCountryForChile < ActiveRecord::Migration[6.0]
  def up
    Country.find_or_create_by(name: 'chile', name_ko: '칠레', locale: 'es', short_name: 'cl', iso_code: 'CLP')
  end

  def down
    Country.find_by_name(name: 'chile').delete
  end
end
