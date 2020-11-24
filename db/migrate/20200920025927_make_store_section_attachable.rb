class MakeStoreSectionAttachable < ActiveRecord::Migration[6.0]
  def change
    add_reference :store_sections, :attachable, polymorphic: true
  end
end
