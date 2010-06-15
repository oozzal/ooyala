# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'ooyala/version'

Gem::Specification.new do |s|
  s.name        = 'ooyala'
  s.version     = Ooyala::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = [ 'Jonah Burke' ]
  s.email       = [ 'jonah@bigthink.com' ]
  s.homepage    = ''
  s.summary     = 'A ruby client for the Ooyala API'
  s.description = s.summary

  s.required_ruby_version = '~> 1.8.6'
  s.required_rubygems_version = '>= 1.3.5'

  s.files        = Dir.glob( 'lib/**/*' )
  s.require_path = 'lib'

  s.add_dependency 'libxml-ruby', '>= 1.1.3'
end