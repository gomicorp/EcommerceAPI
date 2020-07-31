# frozen_string_literal: true

require_relative 'helper'

Rake::Helper.rake_alias 'db:migrate', 'db:migrate:with_data' do
  Rake::Task[:annotate_models].invoke if Rails.env.development?
end

Rake::Helper.rake_alias 'db:rollback', 'db:rollback:with_data' do
  Rake::Task[:annotate_models].invoke if Rails.env.development?
end

Rake::Helper.rake_alias 'db:migrate:status', 'db:migrate:status:with_data'
Rake::Helper.rake_alias 'db:version', 'db:version:with_data'
Rake::Helper.rake_alias 'db:schema:load', 'db:schema:load:with_data'
Rake::Helper.rake_alias 'db:structure:load', 'db:structure:load:with_data'
