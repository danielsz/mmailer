module Mmailer
  class Worker
    attr_reader :obj, :mailHelper, :collection, :from

    def initialize(from)
      @from = from
      @obj = DRbObject.new_with_uri('druby://localhost:12345')
      meta = { title: "Test email", template: "test", provider: :google }
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
            sleep rand(6)
            if index % 48 == 0
              obj.puts "48th element, going to sleep for an hour"
              sleep 3600
            end
          when :stopped
            break
        end
      end
      obj.puts "Exiting worker"
      Thread.exit
    end

    def load_collection
      @collection = User.active
      collection.shift(from)
      obj.puts "Loaded #{collection.count} entries"
    end

  end
end