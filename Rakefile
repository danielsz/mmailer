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

task :start do
  client(:start)
end

task :pause do
  client(:start)
end
task :resume do
  client(:start)
end
task :stop do
  client(:start)
end

private

def client(cmd)
  require 'drb/drb'
  uri = 'druby://localhost:12345'
  begin
    obj = DRbObject.new_with_uri(uri)
    obj.send(cmd)
  rescue DRb::DRbConnError => e
    puts e.message + "\nIs the server running? (You can start the server with)"
  end
end


=begin
  #uri = ARGV.shift
if obj.up?
  puts "OK, connection with server established"
else
  puts "There was a problem establishing a connection with the server"
end
=end
