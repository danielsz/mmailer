module Mmailer
  module Client
    def client(cmd, args=nil)
      require 'drb/drb'
      uri = 'druby://localhost:12345'
      begin
        obj = DRbObject.new_with_uri(uri)
        if args
          obj.send(cmd, args)
        else
          obj.send(cmd)
        end
      rescue DRb::DRbConnError => e
        puts e.message + "\nIs the server running? (You can start the server with `mmailer server`)"
      end
    end
  end
end
