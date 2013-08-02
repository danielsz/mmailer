require "mmailer/version"

module Mmailer

  require 'mail'
  require 'micromachine'
  require 'kramdown'
  require 'erb'
  require 'drb/drb'
  require 'mmailer/config'
  require 'mmailer/providers'
  require 'mmailer/server'
  require 'mmailer/server_helper'
  require 'mmailer/error_handling'
  require 'mmailer/mail_helper'
  require 'mmailer/worker'

## read config
  config = File.join(Dir.pwd, 'config.rb')

  if File.exists? config
    load config
  else
    puts "No configuration file found"
  end

end
