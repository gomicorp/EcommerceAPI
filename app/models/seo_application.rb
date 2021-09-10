class SeoApplication < ApplicationRecord
  belongs_to :seo_tag_set
  delegate :page_type, to: :seo_tag_set
  belongs_to :page, polymorphic: true, optional: true

  serialize :seo_properties, Hash

end
