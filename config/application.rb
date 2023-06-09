require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MyApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    #生成されるテストファイルをRSpecにし、使用頻度の高くないSpecファイルが生成されないように設定
    config.generators do |g|
      g.test_framework :rspec,
        view_specs: false,
        helper_specs: false,
        routing_specs: false
    end

    # エラーメッセージの日本語化のために追加
    config.i18n.default_locale = :ja
    config.active_model.i18n_customize_full_message = true

    # タイムゾーンを日本時間に設定
    config.time_zone = 'Asia/Tokyo'

    # 画像リサイズ用
    config.active_storage.variant_processor = :mini_magick
    
  end
end
