class CreateSocialMediaServices < ActiveRecord::Migration[6.0]
  def change
    create_table :social_media_services do |t|
      t.string :name

      t.timestamps
    end
  end
end
