class Country < ApplicationRecord
  has_many :brands
  has_many :products

  #validates_uniqueness_of Country.attribute_names
  validates_presence_of :name, :name_ko, :locale, :short_name
  alias_attribute :code, :short_name

  TH = find_or_create_by(name: 'thailand', name_ko: '태국', locale: 'th', short_name: 'th', iso_code: 'THB')
  VN = find_or_create_by(name: 'vietnam', name_ko: '베트남', locale: 'vi', short_name: 'vn', iso_code: 'VND')
  KO = find_or_create_by(name: 'korea', name_ko: '한국', locale: 'ko', short_name: 'ko', iso_code: 'KRW')

  def self.th
    TH
  end

  def self.vn
    VN
  end

  def self.ko
    KO
  end

  def self.undef
    where(short_name: nil)
  end

  def self.at(key)
    find_by(short_name: key)
  end

  def self.global
    all
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
      { name: 'thailand', name_ko: '태국', locale: 'th', short_name: 'th' },
      { name: 'korea', name_ko: '한국', locale: 'ko', short_name: 'ko' }
    ]
  end
end
