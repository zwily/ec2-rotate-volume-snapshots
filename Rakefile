require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "ec2-rotate-volume-snapshots"
  gem.homepage = "http://github.com/zwily/ec2-rotate-volume-snapshots"
  gem.license = "MIT"
  gem.summary = %Q{Amazon EC2 snapshot rotator}
  gem.description = %Q{Provides a simple way to rotate EC2 snapshots with configurable retention periods.}
  gem.email = "zach@zwily.com"
  gem.authors = ["Zach Wily"]
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ec2-rotate-volume-snapshots #{version}"
  rdoc.rdoc_files.include('README*')
end
