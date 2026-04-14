require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.secret_key_base = ENV.fetch("SECRET_KEY_BASE", SecureRandom.hex(64))

  config.enable_reloading = false
  config.eager_load = true
  config.cache_classes = true

  config.consider_all_requests_local = false

  config.cache_store = :memory_store

  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.year.to_i}"
  }

  config.active_support.deprecation = :notify
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []
end
