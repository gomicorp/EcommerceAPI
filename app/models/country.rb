class Country < ApplicationRecord
  has_many :brands
  has_many :products

  validates_presence_of :name, :name_ko, :locale
end
