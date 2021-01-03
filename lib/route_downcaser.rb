# frozen_string_literal: true

require 'route_downcaser/downcase_route_middleware'
require 'route_downcaser/railtie' if defined? Rails
require 'route_downcaser/configuration'

module RouteDowncaser
  extend RouteDowncaser::Configuration

  define_setting :redirect, false
  define_setting :exclude_patterns, [%r{assets/}i]
end
