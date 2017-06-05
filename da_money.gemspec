$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "da_money/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "da_money"
  s.version     = DaMoney::VERSION
  s.authors     = ["Stefan Große"]
  s.email       = ["stefan@grosse.io"]
  s.homepage    = "https://grosse.io/"
  s.summary     = "da_money is a currency conversion gem for DaWanda."
  s.description = "da_money enables you to convert money amounts into different currencies."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_development_dependency "bundler", "~> 1.14"
  s.add_development_dependency "rspec"
end
