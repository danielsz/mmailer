module Mmailer
  def Mmailer.start_server
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