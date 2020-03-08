class Country < ApplicationRecord
  has_many :brands
  has_many :products

  validates_presence_of :name, :name_ko, :locale, :short_name

  def self.th
    find_by(short_name: 'th')
  end

  def self.vn
    find_by(short_name: 'vn')
  end

  def self.undef
    where(short_name: nil)
  end

  def self.at(key)
    find_by(short_name: key)
  end

  def self.migrate_input_seed_data
    transaction do
      seed_data.each do |country_seed|
        country = Country.find_or_initialize_by(name: country_seed[:name])
        country.assign_attributes(country_seed)
        country.save!
      end
    end
  end

  def self.seed_data
    [
      { name: 'vietnam', name_ko: '베트남', locale: 'vi', short_name: 'vn' },
      { name: 'thailand', name_ko: '태국', locale: 'th', short_name: 'th' }
    ]
  end
end
