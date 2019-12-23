class Zohomap < ApplicationRecord
  belongs_to :zohoable, polymorphic: true
end
