require 'mmailer/client'

class MyCLI < Thor
  include Mmailer::Client

  desc "server", "Start server."
  def server
    require 'mmailer'
    Mmailer.start_server
  end

  desc "start FROM", "Start an email run from FROM (default is 0, start of the collection)."
  def start(from=0)
    client(:start, from.to_i)
  end

  desc "pause", "Pause an email run."
  def pause
    client(:pause)
  end

  desc "resume", "Resume an email run."
  def resume
    client(:resume)
  end

  desc "stop", "Stop an email run and exit server."
  def stop
    client(:stop)
  end

  desc "version", "Show mmailer version"
  def version
    require 'mmailer/version'
    puts Mmailer::VERSION
  end

  desc "config", "Real-time mail queue configuration"
  option :time_interval, :type => :numeric
  option :mail_interval, :type => :numeric
  option :sleep_time, :type => :numeric
  def config
    require 'mmailer/config'
    if options.empty?
      puts "No options provided. Configuration unchanged."
      puts "Sleep time: #{Mmailer.configuration.sleep_time} seconds"
      puts "Mail interval time: #{Mmailer.configuration.mail_interval} seconds"
      puts "Time interval: #{Mmailer.configuration.time_interval} seconds"
    else
      Mmailer.configuration.sleep_time = options.fetch(:sleep_time, Mmailer.configuration.sleep_time)
      Mmailer.configuration.mail_interval = options.fetch(:mail_interval, Mmailer.configuration.mail_interval)
      Mmailer.configuration.time_interval = options.fetch(:sleep_time, Mmailer.configuration.time_interval)
      puts "OK."
    end
  end

end
