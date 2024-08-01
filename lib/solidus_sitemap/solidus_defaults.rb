# frozen_string_literal: true

module SolidusSitemap::SolidusDefaults
  include Spree::Core::Engine.routes.url_helpers
  include Spree::BaseHelper # for meta_data

  def default_url_options
    { host: SitemapGenerator::Sitemap.default_host }
  end

  def add_login(options = {})
    add(main_app.login_path, options)
  end

  def add_signup(options = {})
    add(main_app.signup_path, options)
  end

  def add_account(options = {})
    add(main_app.account_path, options)
  end

  def add_password_reset(options = {})
    add(main_app.new_spree_user_password_path, options)
  end

  def add_products(options = {})
    available_products = Spree::Product.available.distinct

    add(main_app.products_path, options.merge(lastmod: available_products.last_updated))
    available_products.find_each do |product|
      add_product(product, options)
    end
  end

  def add_product(product, options = {})
    opts = options.merge(lastmod: product.updated_at)

    if gem_available?('spree_videos') && product.videos.present?
      # TODO: add exclusion list configuration option
      # https://sites.google.com/site/webmasterhelpforum/en/faq-video-sitemaps#multiple-pages

      # don't include all the videos on the page to avoid duplicate title warnings
      primary_video = product.videos.first
      opts[:video] = [video_options(primary_video.youtube_ref, product)]
    end

    add(main_app.product_path(product), opts)
  end

  def add_pages(options = {})
    if gem_available? 'spree_essential_cms'
      Spree::Page.active.each do |page|
        add_page(page, options.merge(attr: :path))
      end
    end

    if gem_available? 'spree_static_content'
      Spree::Page.visible.each do |page|
        add_page(page, options.merge(attr: :slug))
      end
    end
  end

  def add_page(page, options = {})
    opts = options.merge(lastmod: page.updated_at)
    attr = opts.delete(:attr)
    add(page.send(attr), opts)
  end

  def add_taxons(options = {})
    Spree::Taxon.roots.each { |taxon| add_taxon(taxon, options) }
  end

  def add_taxon(taxon, options = {})
    add(main_app.nested_taxons_path(taxon.permalink), options.merge(lastmod: taxon.products.last_updated)) if taxon.permalink.present?
    taxon.children.each { |child| add_taxon(child, options) }
  end

  def gem_available?(name)
    Gem::Specification.find_by_name(name) # rubocop:disable Rails/DynamicFindBy
  rescue Gem::LoadError
    false
  rescue StandardError
    Gem.available?(name)
  end

  def main_app
    Rails.application.routes.url_helpers
  end

  private

  ##
  # Multiple videos of the same ID can exist, but all videos linked in the sitemap should be inique
  #
  # Required video fields:
  # http://www.seomoz.org/blog/video-sitemap-guide-for-vimeo-and-youtube
  #
  # YouTube thumbnail images:
  # http://www.reelseo.com/youtube-thumbnail-image/
  #
  # NOTE title should match the page title, however the title generation isn't self-contained
  # although not a future proof solution, the best (+ easiest) solution is to mimic the title for product pages
  #   https://github.com/solidusio/solidus/blob/1-3-stable/core/lib/spree/core/controller_helpers/common.rb#L39
  #   https://github.com/solidusio/solidus/blob/1-3-stable/core/app/controllers/spree/products_controller.rb#L41
  #
  def video_options(youtube_id, object = false)
    (begin
       { description: meta_data(object)[:description] }
     rescue StandardError
       {}
     end).merge(
       (begin
          { title: [Spree::Config[:site_name], object.name].join(' - ') }
        rescue StandardError
          {}
        end)
     ).merge(
       thumbnail_loc: "http://img.youtube.com/vi/#{youtube_id}/0.jpg",
       player_loc: "http://www.youtube.com/v/#{youtube_id}",
       autoplay: 'ap=1'
     )
  end
end
