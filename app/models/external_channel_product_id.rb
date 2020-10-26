class ExternalChannelProductId < ApplicationRecord
  belongs_to :product, dependent: :destroy
  belongs_to :channel, dependent: :destroy

  def search

  end
end
