require "mmailer/version"

module Mmailer
  require 'bundler'
  require 'mail'
  require 'erb'
  require 'mmailer/master_helper'
  require 'mmailer/mail_helper'
  require 'mmailer/worker'

# read config

  config = File.join(Bundler.root, 'config.rb')

  if File.exists? config
    load config
  else
    puts "No configuration file found"
  end

  def start_server
    require 'drb/drb'
    require 'micromachine'
    #uri = ARGV.shift
    uri = 'druby://localhost:12345'
    DRb.start_service(uri, Mmailer::MasterHelper.new)
    puts DRb.uri
    begin
      DRb.thread.join
    rescue Interrupt
        abort "Shutting down..."
    end
  end
end
