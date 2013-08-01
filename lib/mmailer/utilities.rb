module Mmailer
  module Utilities

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

    def try(number_of_times=3)
        retry_count = 0
        begin
          yield
        rescue Net::OpenTimeout, EOFError => e
          retry_count += 1
          puts  "#{e.class}: #{e.message}: #{retry_count} retries"
          sleep retry_count
          if retry_count < number_of_times
            retry
          else
            puts "Too many errors. Pausing mail queue."
            client(:pause)
          end
          nil
        end
    end

    at_exit do
      if $!
        puts "We're going down: #{$!.message} \n #{$!.backtrace}"
      end
    end
  end
end