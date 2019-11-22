# frozen_string_literal: true

module SolidusSitemap
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'solidus_sitemap'

    config.autoload_paths += %W[#{config.root}/lib]

    config.to_prepare do
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      require 'solidus_sitemap/solidus_defaults'
      SitemapGenerator::Interpreter.include SolidusSitemap::SolidusDefaults
      if defined? SitemapGenerator::LinkSet
        SitemapGenerator::LinkSet.include SolidusSitemap::SolidusDefaults
      end
    end
  end
end
