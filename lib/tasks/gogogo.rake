# frozen_string_literal: true

require_relative '../../vendor/tasks/helper'


desc 'bundle install'
task bundle: :environment do
  rake.exec "bundle install --with=#{Rails.env}"
end

desc 'db:create db:migrate db:seed'
task dbdbdb: :environment do
  rake 'db:create', 'db:migrate', 'db:seed'
end

desc 'assets:precompile'
task asset: :environment do
  rake 'assets:precompile' if Rails.env.production?
end

desc 'Start script: bundle install + db:migration + asset precompile + server restart'
task gogogo: :environment do
  root_context do
    rake 'bundle', 'dbdbdb', 'asset'
  end
end

desc 'gogogo + server'
task start: :environment do
  rake 'install:all', :gogogo, :server
end
