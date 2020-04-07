class Receiver < ApplicationRecord
  belongs_to :user, dependent: :destroy
end
