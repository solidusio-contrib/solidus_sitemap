# frozen_string_literal: true

require 'spree/core'

module SolidusSitemap
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions

    isolate_namespace ::Spree

    engine_name 'solidus_sitemap'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    config.to_prepare do
      require 'solidus_sitemap/solidus_defaults'

      SitemapGenerator::Interpreter.include SolidusSitemap::SolidusDefaults

      if defined?(SitemapGenerator::LinkSet)
        SitemapGenerator::LinkSet.include SolidusSitemap::SolidusDefaults
      end
    end
  end
end
