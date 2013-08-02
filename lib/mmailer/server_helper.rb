module Mmailer
  class ServerHelper
    attr_accessor :stream, :worker, :machine

    def initialize
      @stream = $stdout
      self.machine = MicroMachine.new(:stopped)
      machine.when(:start, :stopped => :started)
      machine.when(:resume, :paused => :started)
      machine.when(:stop, :started => :stopped, :paused => :stopped)
      machine.when(:pause, :started => :paused)
    end

    def display_state
      stream.puts state
    end

    def state
      machine.state
    end

    def puts(str)
      stream.puts(str)
    end

    def up?
      true
    end

    def resume
      if machine.trigger(:resume)
        display_state
        machine.state
      end
    end

    def stop
      if machine.trigger(:stop)
        display_state
        machine.state
      end
    end

    def pause
      if machine.trigger(:pause)
        display_state
        machine.state
      end
    end

    def start(from=0)
      if machine.trigger(:start)
        puts "starting from #{from}"
        Thread.abort_on_exception = true
        @worker = Thread.new(from) do |from|
          Worker.new(from)
        end
      end
    end

    def config(options=nil)
      if options.nil?
        puts "I will send emails every #{Mmailer.configuration.time_interval} seconds. After #{Mmailer.configuration.mail_interval} emails, I will sleep for #{Mmailer.configuration.sleep_time} seconds."
      else
        Mmailer.configuration.sleep_time = options.fetch("sleep_time", Mmailer.configuration.sleep_time)
        Mmailer.configuration.mail_interval = options.fetch("mail_interval", Mmailer.configuration.mail_interval)
        Mmailer.configuration.time_interval = options.fetch("time_interval", Mmailer.configuration.time_interval)
        puts "#{options}. OK."
      end
    end

  end
end