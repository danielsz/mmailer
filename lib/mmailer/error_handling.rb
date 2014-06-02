module Mmailer
  module ErrorHandling

    def try(number_of_times=3)
        retry_count = 0
        begin
          yield
        rescue Net::OpenTimeout, Net::ReadTimeout, EOFError => e
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
        rescue Net::SMTPUnknownError => e
          puts e.message
          client(:pause)
        end
    end

    at_exit do
      if $!
        puts "We're going down: #{$!.class} \n #{$!.message} \n #{$!.backtrace}"
      end
    end

  end
end