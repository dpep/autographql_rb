require_relative "lib/autographql/version"

Gem::Specification.new do |s|
  s.authors     = ["Daniel Pepper"]
  s.description = "Automagically generate GraphQL types and queries"
  s.files       = `git ls-files * ':!:spec'`.split("\n")
  s.homepage    = "https://github.com/dpep/autographql_rb"
  s.license     = "MIT"
  s.name        = "autographql"
  s.summary     = "AutoGraphQL"
  s.version     = AutoGraphQL::VERSION

  s.required_ruby_version = ">= 3.3"

  s.add_dependency "activerecord", ">= 6"
  s.add_dependency "graphql", ">= 2"

  s.add_development_dependency "debug"
  s.add_development_dependency "rspec"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "sqlite3"
end
