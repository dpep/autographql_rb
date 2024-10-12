Gem::Specification.new do |s|
  s.authors     = ['Daniel Pepper']
  s.description = 'Automagically generate GraphQL types and queries'
  s.files       = `git ls-files * ':!:spec'`.split("\n")
  s.homepage    = 'https://github.com/dpep/autographql_rb'
  s.license     = 'MIT'
  s.name        = File.basename(__FILE__, ".gemspec")
  s.summary     = 'AutoGraphQL'
  s.version     = '0.0.4'

  # s.required_ruby_version = ">= 3"

  s.add_runtime_dependency 'activerecord', '~> 5'
  s.add_runtime_dependency 'graphql', '= 1.8.11'

  s.add_development_dependency 'debug'
  s.add_development_dependency 'rspec', '>= 3.13'
  s.add_development_dependency 'simplecov', '>= 0.22'
  s.add_development_dependency 'sqlite3', '= 1.6'
end
