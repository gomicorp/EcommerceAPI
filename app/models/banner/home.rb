# == Schema Information
#
# Table name: banners
#
#  id            :bigint           not null, primary key
#  active        :boolean          default(FALSE), not null
#  banner_type   :integer          default("home"), not null
#  bannered_type :string(255)
#  href          :string(255)
#  position      :integer          default(1), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  bannered_id   :bigint
#  country_id    :bigint
#
# Indexes
#
#  index_banners_on_bannered_type_and_bannered_id  (bannered_type,bannered_id)
#  index_banners_on_country_id                     (country_id)
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#
module Banner
  class Home < Base
    default_scope -> { where(banner_type: :home) }
  end
end
