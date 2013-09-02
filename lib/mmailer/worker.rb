module Mmailer
  class Worker
    # two froms, not equal
    attr_reader :obj, :mailHelper, :collection, :time_interval, :mail_interval, :sleep_time, :from

    def initialize(from)
      @from = from
      @obj = DRbObject.new_with_uri('druby://localhost:12345')
      meta = { subject: Mmailer.configuration.subject, from:  Mmailer.configuration.from, template: Mmailer.configuration.template, provider: Mmailer.configuration.provider }
      @mailHelper = MailHelper.new(meta)
      load_collection
      exec
    end

    private

    def exec
      while not collection.empty? do
        case obj.state
          when :paused
            sleep 1
          when :started
            load_config
            index ||= from; index += 1
            user = collection.shift
            if not user.email.nil?
              obj.puts "#{index}: #{user.email}"
              mailHelper.send_email(user)
              sleep rand(time_interval)
            else
              obj.puts "#{index}: No email found. Skipping."
            end
            if index % mail_interval == 0
              obj.puts "#{mail_interval} element, going to sleep for #{sleep_time} seconds"
              sleep sleep_time
            end
          when :stopped
            break
        end
      end
      stop
    end

    def load_collection
      @collection = case Mmailer.configuration.collection
                      when Array
                        Mmailer.configuration.collection
                      when Proc
                        Mmailer.configuration.collection.call
                      else
                        obj.puts "Collection needs to be an array or a proc object. It appears to be neither."
                        stop
                    end
      collection.shift(from)
      obj.puts "Loaded #{collection.count} entries"
    end

    def load_config
      @time_interval = Mmailer.configuration.time_interval
      @mail_interval = Mmailer.configuration.mail_interval
      @sleep_time = Mmailer.configuration.sleep_time
    end

    def stop
      obj.puts "Exiting worker, stopping server"
      DRb::stop_service
      Thread.exit
    end
  end
end