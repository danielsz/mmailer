require "mmailer/version"

module Mmailer
  require 'bundler'
  require 'mail'
  require 'micromachine'
  require 'erb'
  require 'mmailer/master_helper'
  require 'mmailer/mail_helper'
  require 'mmailer/worker'

# read config

  config = File.join(Bundler.root, 'config.rb')

  puts Dir.pwd
  if File.exists? config
    load config
  else
    puts "No configuration file found"
  end

end
