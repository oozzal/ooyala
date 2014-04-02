# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = 'ooyala'
  s.version     = '0.1.6'
  s.platform    = Gem::Platform::RUBY
  s.authors     = [ 'Jonah Burke' ]
  s.email       = [ 'jonah@bigthink.com' ]
  s.homepage    = ''
  s.summary     = 'A ruby client for the Ooyala API'
  s.description = s.summary

  s.required_ruby_version = '>= 1.8.6'
  s.required_rubygems_version = '>= 1.3.5'

  s.files        = Dir.glob( 'lib/**/*' )
  s.require_path = 'lib'

  s.add_dependency 'nokogiri'
  s.add_dependency 'activesupport'
  s.add_development_dependency 'rdoc'
end