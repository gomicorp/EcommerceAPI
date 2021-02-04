
module Rolify
  alias _resourcify resourcify

  def resourcify(association_name = :roles, options = {})
    # @company.allow_role(:owner, Manager.first)
    define_method :allow_role do |role_name, user|
      user.add_role(role_name, self)
    end
    send(:_resourcify, association_name, options)
  end

  # Company.allow_role(:admin, Admin.first)
  def allow_role(role_name, user)
    user.add_role(role_name, self)
  end
end

Rolify.configure do |config|
  # By default ORM adapter is ActiveRecord. uncomment to use mongoid
  # config.use_mongoid

  # Dynamic shortcuts for User class (user.is_admin? like methods). Default is: false
  # config.use_dynamic_shortcuts

  # Configuration to remove roles from database once the last resource is removed. Default is: true
  # config.remove_role_if_empty = false
end
