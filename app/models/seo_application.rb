# == Schema Information
#
# Table name: seo_applications
#
#  id             :bigint           not null, primary key
#  page_type      :string(255)
#  seo_properties :text(65535)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  page_id        :integer
#  seo_tag_set_id :bigint
#
# Indexes
#
#  index_seo_applications_on_seo_tag_set_id  (seo_tag_set_id)
#
# Foreign Keys
#
#  fk_rails_...  (seo_tag_set_id => seo_tag_sets.id)
#
class SeoApplication < ApplicationRecord
  belongs_to :seo_tag_set
  delegate :page_type, to: :seo_tag_set
  belongs_to :page, polymorphic: true, optional: true

  serialize :seo_properties, Hash

end
