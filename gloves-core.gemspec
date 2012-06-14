# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','gloves','core', 'version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'gloves-core'
  s.version = Gloves::Core::VERSION
  s.author = 'Your Name Here'
  s.email = 'your@email.address.com'
  s.homepage = 'http://your.website.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Tools for system configuration'
  s.description = 'Set of tools for system configuration'
  s.files         = `git ls-files`.split($\)
  s.require_paths = ['lib']
  s.bindir = 'bin'
  s.executables << 'gloves'

  s.add_runtime_dependency('gli','2.0.0.rc4')

  s.add_development_dependency('rake')
end
