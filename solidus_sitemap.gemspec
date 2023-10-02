# frozen_string_literal: true

$:.push File.expand_path('lib', __dir__)
require 'solidus_sitemap/version'

Gem::Specification.new do |s|
  s.name = 'solidus_sitemap'
  s.version = SolidusSitemap::VERSION
  s.summary = 'Provides a sitemap file for Solidus'
  s.license = 'BSD-3-Clause'

  s.author = 'Nebulab'
  s.email = 'opensource@nebulab.it'
  s.homepage = 'https://nebulab.it'

  if s.respond_to?(:metadata)
    s.metadata["homepage_uri"] = s.homepage if s.homepage
    s.metadata["source_code_uri"] = "https://github.com/solidusio-contrib/solidus_sitemap"
  end

  s.required_ruby_version = '>= 2.4'

  s.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  s.test_files = Dir['spec/**/*']
  s.bindir = "exe"
  s.executables = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'sitemap_generator', '~> 6.0'
  s.add_dependency 'solidus_core', '>= 2.0.0', '< 5'
  s.add_dependency 'solidus_support', '~> 0.5'

  s.add_development_dependency 'solidus_dev_support'
end
