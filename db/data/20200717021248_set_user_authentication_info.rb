class SetUserAuthenticationInfo < ActiveRecord::Migration[6.0]
  def up
    ApplicationRecord.country_context_with 'global' do
      User.all.each do |user|
        if user.provider.nil?
          user.provider = 'gomi'
          user.uid = DateTime.current.to_i.to_s + SecureRandom.uuid
        end

        Authentication.create!(user_id: user.id,
                               provider: user.provider,
                               uid: user.uid) unless Authentication.find_by(user_id: user.id,
                                                                     provider: user.provider,
                                                                     uid: user.uid)
      end
    end
  end

  def down
    # raise ActiveRecord::IrreversibleMigration
  end
end
