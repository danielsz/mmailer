module Mmailer
  class Worker
    attr_reader :obj, :mailHelper, :collection, :from

    def initialize(from)
      @from = from
      @obj = DRbObject.new_with_uri('druby://localhost:12345')
      meta = { subject: Mmailer.configuration.subject, template: Mmailer.configuration.template, provider: Mmailer.configuration.provider }
      @mailHelper = MailHelper.new(meta)
      load_collection
      exec
    end

    def exec
      while not collection.empty? do
        case obj.state
          when :paused
            sleep 1
          when :started
            index ||= from; index += 1
            user = collection.shift
            obj.puts "#{index}: #{user.email}"
            mailHelper.send_email(user) if not user.email.nil?
            sleep rand(Mmailer.configuration.time_interval)
            if index % Mmailer.configuration.mail_interval == 0
              obj.puts "#{Mmailer.configuration.mail_interval} element, going to sleep for #{Mmailer.configuration.sleep_time} seconds"
              sleep Mmailer.configuration.sleep_time
            end
          when :stopped
            break
        end
      end
      obj.puts "Exiting worker, stopping server"
      DRb::stop_service
      Thread.exit
    end

    def load_collection
      @collection = Mmailer.configuration.collection.call
      collection.shift(from)
      obj.puts "Loaded #{collection.count} entries"
    end

  end
end