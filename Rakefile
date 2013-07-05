require "bundler/gem_tasks"
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -I lib -I lib/mmailer -r mmailer.rb"
end

task :master do
  sh "irb -rubygems -I lib -I lib/mmailer -r mmailer.rb -r master.rb"
end

task :slave do
  sh "irb -rubygems -I lib -I lib/mmailer -r mmailer.rb -r client.rb"
end