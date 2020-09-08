class AddGomiAuthenticationToUsers < ActiveRecord::Migration[6.0]
  def up
    User.all.each do |user|
      next if user.authentications.where(provider: 'gomi').any?

      uid = user.created_at.to_i.to_s << SecureRandom.hex(3)
      gomi_auth = Authentication.new(provider: 'gomi', uid: uid)
      user.authentications << gomi_auth
      user.save!
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
