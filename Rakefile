require 'rubygems'
require 'rubygems/specification'
require 'rake/testtask'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'lib/ooyala'

spec = Gem::Specification.new do |s|
  s.name    = "ooyala"
  s.platform = Gem::Platform::RUBY
  s.version = Ooyala::VERSION
  s.authors = ["Jonah Burke"]
  s.email = ["jonah@bigthink.com"]
  s.description = s.summary = "A Ruby client for the Ooyala API"
  s.required_rubygems_version = ">= 1.3.5"
  s.require_path = 'lib'
  s.files = Dir.glob( "lib/**/*" )
  # s.homepage = ""
  # s.has_rdoc = true
  # s.extra_rdoc_files = ["README.markdown", "LICENSE"]

  s.add_dependency 'libxml-ruby', '>= 1.1.3'
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = 'test/*_test.rb'
  t.verbose = true
  t.warning = false
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
end

desc "install the gem locally"
task :install => [:package] do
  sh %{gem install pkg/#{spec.name}-#{spec.version}}
end

desc "create a gemspec file"
task :make_spec do
  File.open("#{spec.name}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

task :gem => :make_spec