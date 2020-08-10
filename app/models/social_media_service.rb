# == Schema Information
#
# Table name: social_media_services
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class SocialMediaService < ApplicationRecord
end
