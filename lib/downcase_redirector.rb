require 'downcase_redirector/downcase_redirector_middleware'
require 'downcase_redirector/railtie' if defined? Rails

module DowncaseRedirector
  # Turns on/off redirection behavior. Defaults to false (original behavior).
  mattr_accessor :redirect
  self.redirect = false
end
