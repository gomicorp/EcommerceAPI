class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  extend AutoIncrement
  extend ParseCountryCode
  include HistoricalRecordable

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

  def self.associations
    reflect_on_all_associations.map do |reflect|
      {klass: reflect.klass, name: reflect.name, options: reflect.options}
    end
  end

  def self.association_names
    associations.pluck(:name)
  end

  def associations
    self.class.associations
  end

  def association_names
    self.class.association_names
  end
end
