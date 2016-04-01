# Solidus Sitemap

Solidus Sitemap is a sitemap generator based on the [sitemap_generator][1] gem.
It adheres to the Sitemap 0.9 protocol specification. This is a continuation of
the [original Spree version](https://github.com/spree-contrib/spree_sitemap),
updated to work with the [Solidus](https://solidus.io) eCommerce platform.

### Features

- Notifies search engine of new sitemaps (Google, Yahoo, Ask, Bing)
- Supports large huge product catalogs
- Adheres to 0.9 Sitemap protocol specification
- Compresses sitemaps with gzip
- Provides basic sitemap of a Solidus site (products, taxons, login page, signup page)
- Easily add additional sitemaps for pages you add to your solidus site
- Supports Amazon S3 and other hosting services
- Thin wrapper over battle tested sitemap generator

### Configuration Options

Check out the [README][1] for the [sitemap_generator][1].

---

## Installation

1) add the gem to your `Gemfile`:
```ruby
gem 'solidus_sitemap', github: 'StemboltHQ/solidus_sitemap', branch: 'master'
```

2) run bundler:

`bundle install`

3) run the installer, it will create a `config/sitemap.rb` file with some sane defaults

`rails g solidus_sitemap:install`

4) add sitemap to your `.gitignore`

`echo "public/sitemap*" >> .gitignore`

5) setup a daily cron job to regenrate your sitemap via the `rake sitemap:refresh` task. If you use the Whenever gem, add this to your `config/schedule.rb`
```ruby
every 1.day, at: '5:00 am' do
  rake '-s sitemap:refresh'
end
```

6) make sure crawlers can find the sitemap, by adding the following line to your `public/robots.txt` with your correct domain name

`echo "Sitemap: http://www.example.com/sitemap.xml.gz" >> public/robots.txt`

**Thanks**

- [The creators & contributors of sitemap_generator](http://github.com/kjvarga/sitemap_generator/contributors)
- [Joshua Nussbaum's original implementation of spree-sitemap-generator](https://github.com/joshnuss/spree-sitemap-generator)

---

## Upgrading

If you upgrade from early versions of `solidus_sitemap` you need to change your sitemaps from:
```ruby
SitemapGenerator::Sitemap.add_links do
  # ...
end
```

to this:
```ruby
SitemapGenerator::Sitemap.create do
  # ...
end
```

---

## Contributing

See corresponding [guidelines][2]

---

Copyright (c) 2016 [Stembolt](https://stembolt.com/)

Copyright (c) 2011-2015 [Jeff Dutil][5] and other [contributors][6], released under the [New BSD License][4].

[1]: http://github.com/kjvarga/sitemap_generator
[2]: https://github.com/spree-contrib/spree_i18n/blob/master/CONTRIBUTING.md
[4]: https://github.com/spree-contrib/spree_sitemap/blob/master/LICENSE.md
[5]: https://github.com/jdutil
[6]: https://github.com/StemboltHQ/solidus_sitemap/graphs/contributors
