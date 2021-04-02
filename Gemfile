# frozen_string_literal: true

source 'http://rubygems.org'

gemspec

###############################################
# Enable testing of multiple rails versions
rails_version = ENV['RAILS_VERSION'] || 'default'
rails = case rails_version
        when 'main'
          { github: 'rails/rails', branch: 'main' }
        when 'default'
          '>= 6.1.0'
        else
          "~> #{rails_version}"
        end
gem 'rails', rails
###############################################

###############################################
# The following gems are also needed to test within the Rails env
gem 'jquery-rails'
gem 'turbolinks'
###############################################

group :test do
  gem 'codeclimate-test-reporter', '~> 1.0.0'
  gem 'simplecov'
end
