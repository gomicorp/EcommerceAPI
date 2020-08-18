# frozen_string_literal: true

LocaleRouter.configuration(Rails) do |config|
  config.available_locales = %w[en ko th]
  config.default_locale = :ko
  config.auto_follow_access_header = false
  config.auto_prepend_before_action = false
  config.locale_param_matcher = :week unless %w[production staging didimdol].include?(Rails.env)
end
