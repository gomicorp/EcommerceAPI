# frozen_string_literal: true

require_relative 'helper'

rake.alias 'db:migrate', 'db:migrate:with_data' do
  rake :annotate_models if Rails.env.development?
end

rake.alias 'db:rollback', 'db:rollback:with_data' do
  rake :annotate_models if Rails.env.development?
end

rake.alias 'db:migrate:status', 'db:migrate:status:with_data'
rake.alias 'db:version', 'db:version:with_data'
rake.alias 'db:schema:load', 'db:schema:load:with_data'
rake.alias 'db:structure:load', 'db:structure:load:with_data'
