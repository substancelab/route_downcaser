require 'route_downcaser/downcase_route_middleware'
require 'route_downcaser/railtie' if defined? Rails
require 'route_downcaser/configuration'

module RouteDowncaser
  extend RouteDowncaser::Configuration

  define_setting :redirect, false
  define_setting :include_patterns
  define_setting :exclude_patterns, [/assets\//i]
end
