# frozen_string_literal: true

require_relative '../../vendor/tasks/helper'

namespace :credit do
  %i[development staging production].each do |env_name|
    desc "EDITOR=vi rails credentials:edit " + (env_name == :production ? '' : "-e #{env_name}")
    task env_name => :environment do
      argv = if env_name == :production
               []
             else
               ['-e', env_name.to_s]
             end

      ENV['EDITOR'] ||= 'vi'
      Rails::Command.invoke 'credentials:edit', argv
    end
  end
end

desc "rails credit:#{ENV['RAILS_ENV'] || 'development'}"
task credit: :environment do
  rake "credit:#{Rails.env}"
end
