$LOAD_PATH.unshift 'lib'
package_name = File.basename __FILE__, '.gemspec'
require "#{package_name}"

klass_name = Object.constants.reverse.find do |c|
  c.to_s.downcase == package_name
end
package = Object.const_get klass_name


Gem::Specification.new do |s|
  s.name        = package_name
  s.version     = package.const_get 'VERSION'
  s.authors     = ['Daniel Pepper']
  s.summary     = package.to_s
  s.description = 'Automagically generate GraphQL types and queries'
  s.homepage    = "https://github.com/dpep/rb_#{package_name}"
  s.license     = 'MIT'

  s.files       = Dir.glob('lib/**/*')
  s.test_files  = Dir.glob('test/**/test_*')

  s.add_runtime_dependency 'activerecord'
  s.add_runtime_dependency 'graphql'

  s.add_development_dependency 'byebug'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'sqlite3'
end
