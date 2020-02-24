class ApplicationRecord < ActiveRecord::Base
  extend AutoIncrement
  extend ParseCountryCode
  self.abstract_class = true

  def cls
    self.class
  end

  def self.extend_has_one_attached(name)
    has_one_attached name.to_sym
    scope "#{name}_attached".to_sym, -> { left_joins("#{name}_attachment".to_sym).where('active_storage_attachments.id is NOT NULL') }
    scope "#{name}_unattached".to_sym, -> { left_joins("#{name}_attachment".to_sym).where('active_storage_attachments.id is NULL') }
  end

  def self.extend_has_many_attached(name)
    has_many_attached name.to_sym
    scope "#{name}_attached".to_sym, -> { left_joins("#{name}_attachments".to_sym).where('active_storage_attachments.id is NOT NULL') }
    scope "#{name}_unattached".to_sym, -> { left_joins("#{name}_attachments".to_sym).where('active_storage_attachments.id is NULL') }
  end
end
