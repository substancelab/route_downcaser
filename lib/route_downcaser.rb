require 'route_downcaser/downcase_route_middleware'
require 'route_downcaser/railtie' if defined? Rails
require 'configuration'

module RouteDowncaser
  extend Configuration

  define_setting :redirect, false
end
