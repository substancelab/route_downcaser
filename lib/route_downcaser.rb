require 'route_downcaser/downcase_route_middleware'
require 'route_downcaser/railtie' if defined? Rails

module RouteDowncaser
  # Turns on/off redirection behavior. Defaults to false (original behavior).
  mattr_accessor :redirect
  self.redirect = false
end
