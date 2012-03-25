$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "community_resolver/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "community_resolver"
  s.version     = CommunityResolver::VERSION
  s.authors     = ["Mike Mell"]
  s.email       = ["mike.mell@nthwave.net"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of CommunityResolver."
  s.description = "TODO: Description of CommunityResolver."

  s.require_paths = ["lib"]

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", ">= 3.1.1"

end
