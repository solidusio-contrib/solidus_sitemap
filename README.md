# Solidus Sitemap

[![Build Status](https://circleci.com/gh/solidusio-contrib/solidus_sitemap.svg?style=svg)](https://circleci.com/gh/solidusio-contrib/solidus_sitemap)

Solidus Sitemap is a sitemap generator based on the
[sitemap_generator](https://github.com/kjvarga/sitemap_generator) gem. It adheres to the Sitemap
0.9 protocol specification.

## Capabilities

- Adheres to the 0.9 Sitemap protocol specification
- Notifies search engines of new sitemap versions
- Supports large product catalogs
- Compresses sitemaps with gzip
- Allows you to easily add additional sitemaps for custom pages in your site
- Supports Amazon S3 and other hosting services

## Installation

First of all, add the gem to your store's `Gemfile`:

```ruby
gem 'solidus_sitemap', github: 'solidusio-contrib/solidus_sitemap'
```

Bundle your dependencies:

```console
$ bundle install
```

Run the installer, which will create a `config/sitemap.rb` file with some sane defaults:

```console
$ rails g solidus_sitemap:install
```

Set up a cron job to regenerate your sitemap via the `rake sitemap:refresh` task. If you use the
[Whenever gem](https://github.com/javan/whenever), add this to your `config/schedule.rb`:

```ruby
every 1.day, at: '5:00 am' do
 rake '-s sitemap:refresh'
end
```

Ensure crawlers can find the sitemap by adding the following line to your `public/robots.txt` with
your own domain:

```console
$ echo "Sitemap: http://www.example.com/sitemap.xml.gz" >> public/robots.txt
```

## Upgrading

If you're upgrading from early versions of `solidus_sitemap`, you need to change your sitemaps from
this:

```ruby
SitemapGenerator::Sitemap.add_links do
  # ...
end
```

To this:

```ruby
SitemapGenerator::Sitemap.create do
  # ...
end
```

## Configuration

Check out the [readme](https://github.com/kjvarga/sitemap_generator/blob/master/README.md) of the
[sitemap_generator](https://github.com/kjvarga/sitemap_generator) gem.

## Contributing

### Releasing new versions

#### 1. Bump gem version and push to RubyGems

We use [gem-release](https://github.com/svenfuchs/gem-release) to release this extension with ease.

Supposing you are on the master branch and you are working on a fork of this extension, `upstream`
is the main remote and you have write access to it, you can simply run:

```bash
gem bump --version minor --tag --release
```

This command will:

- bump the gem version to the next minor (changing the `version.rb` file)
- commit the change and push it to upstream master
- create a git tag
- push the tag to the upstream remote
- release the new version on RubyGems

Or you can run these commands individually:

```bash
gem bump --version minor
gem tag
gem release
```

#### 2. Publish the updated CHANGELOG

After the release is done we can generate the updated CHANGELOG using
[github-changelog-generator](https://github.com/github-changelog-generator/github-changelog-generator)
by running the following command:

```bash
bundle exec github_changelog_generator solidusio/solidus_sitemap --token YOUR_GITHUB_TOKEN
git commit -am 'Update CHANGELOG'
git push upstream master
```

## Acknowledgements

- [The original Spree version of this gem](https://github.com/spree-contrib/spree_sitemap)
- [The creators & contributors of sitemap_generator](http://github.com/kjvarga/sitemap_generator/contributors)
- [Joshua Nussbaum's original implementation of spree-sitemap-generator](https://github.com/joshnuss/spree-sitemap-generator)

## License

![Nebulab](http://nebulab.it/assets/images/public/logo.svg)

Copyright (c) 2019 [Nebulab](https://nebulab.it).

Copyright (c) 2016-2018 [Stembolt](https://stembolt.com/).

Copyright (c) 2011-2015 [Jeff Dutil](https://github.com/jdutil) and
[other contributors](https://github.com/solidusio-contrib/solidus_sitemap/graphs/contributors),
released under the [New BSD License](https://github.com/kjvarga/sitemap_generator/blob/master/MIT-LICENSE).
