# coding: utf-8
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'solidus_sitemap/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'solidus_sitemap'
  s.version     = SolidusSitemap::VERSION
  s.summary     = 'Provides a sitemap file for Solidus'
  s.description = s.summary
  s.required_ruby_version = '>= 2.1.0'

  s.author            = 'Nebulab'
  s.email             = 'opensource@nebulab.it'
  s.homepage          = 'https://nebulab.it'

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- spec/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_runtime_dependency 'sitemap_generator', '~> 6.0.1'
  s.add_runtime_dependency 'solidus_core', ['>= 1.1', '< 3']

  s.add_development_dependency 'gem-release'
  s.add_development_dependency 'github_changelog_generator'
  s.add_development_dependency 'solidus_extension_dev_tools'
end
