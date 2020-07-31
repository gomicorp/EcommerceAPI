# == Schema Information
#
# Table name: users
#
#  id                        :bigint           not null, primary key
#  birth_day                 :date
#  email                     :string(255)      default(""), not null
#  encrypted_password        :string(255)      default(""), not null
#  gender                    :string(255)
#  invite_confirmation_token :string(255)
#  is_admin                  :boolean
#  is_manager                :boolean
#  is_seller                 :boolean
#  name                      :string(255)
#  phone_number              :string(255)
#  profile_image             :string(255)
#  remember_created_at       :datetime
#  reset_password_sent_at    :datetime
#  reset_password_token      :string(255)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  default_address_id        :bigint
#  default_receiver_id       :bigint
#
# Indexes
#
#  index_users_on_default_address_id    (default_address_id)
#  index_users_on_default_receiver_id   (default_receiver_id)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class Admin < User
  default_scope -> { admins }
end
