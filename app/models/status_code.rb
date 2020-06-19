class StatusCode < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
end
