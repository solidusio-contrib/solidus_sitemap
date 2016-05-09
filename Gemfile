source "https://rubygems.org"

branch = ENV.fetch('SOLIDUS_BRANCH', 'master')
gem "solidus", github: "solidusio/solidus", branch: branch

gem 'mysql'
gem 'pg'

group :development, :test do
  gem "pry-rails"
end

gemspec
