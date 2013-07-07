module Mmailer
  def self.start_server
    require 'drb/drb'
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