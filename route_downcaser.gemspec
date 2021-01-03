# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'route_downcaser/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'route_downcaser'
  s.version     = RouteDowncaser::VERSION
  s.licenses    = ['MIT']
  s.authors     = ['Carsten Gehling']
  s.email       = ['carsten@sarum.dk']
  s.homepage    = 'https://github.com/carstengehling/route_downcaser'
  s.summary     = 'Makes routing in Rails case-insensitive'
  s.description = "This gem hooks into the Rack middleware of Rails. This way all paths are downcased before dispatching to Rails' routing mechanism. Querystring parameters are not changed in any way."

  s.files = Dir['{lib}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']
  s.add_runtime_dependency 'activesupport', '>= 3.2'
end
