$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "downcase_redirector/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "downcase_redirector"
  s.version     = RouteDowncaser::VERSION
  s.authors     = ["FoodyDirect", "Carsten Gehling"]
  s.email       = ["alex@foodydirect.com", "carsten@sarum.dk"]
  s.homepage    = "https://github.com/foody_direct/downcase_redirector"
  s.summary     = "Case-insensitive 301 redirects to downcased URIs"
  s.description = "This gem hooks into the Rack middleware of Rails. This way all paths are downcased before dispatching to Rails' routing mechanism. Querystring parameters are not changed in any way."

  s.files = Dir["{lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]
end
