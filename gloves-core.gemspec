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
# Add your other files here if you make them
  s.files         = `git ls-files`.split($\)
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','gloves-core.rdoc']
  s.rdoc_options << '--title' << 'gloves-core' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'gloves'

  s.add_runtime_dependency('gli','2.0.0.rc4')

  s.add_development_dependency('rake')
end
