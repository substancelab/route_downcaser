# frozen_string_literal: true

source "http://rubygems.org"

gemspec

if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.3.0")
  gem "base64"
  gem "bigdecimal"
  gem "drb"
  gem "mutex_m"
end

###############################################
# Enable testing of multiple rails versions
rails_version = ENV["RAILS_VERSION"] || "default"
rails = case rails_version
when "main"
  {github: "rails/rails", branch: "main"}
when "default"
  ">= 8.0.0"
else
  "~> #{rails_version}"
end
gem "rails", rails
###############################################

group :test do
  gem "codeclimate-test-reporter", "~> 1.0.0"
  gem "propshaft"
  gem "simplecov"
end
