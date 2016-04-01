module SolidusSitemap
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'solidus_sitemap'

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      Spree::Product.class_eval do
        def self.last_updated
          last_update = order('spree_products.updated_at DESC').first
          last_update.try(:updated_at)
        end
      end

      require 'solidus_sitemap/solidus_defaults'
      SitemapGenerator::Interpreter.send :include, SolidusSitemap::SolidusDefaults
      if defined? SitemapGenerator::LinkSet
        SitemapGenerator::LinkSet.send :include, SolidusSitemap::SolidusDefaults
      end
    end

    config.to_prepare(&method(:activate).to_proc)
  end
end
