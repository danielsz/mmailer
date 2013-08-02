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
    if options.empty?
      client(:config)
    else
      client(:config, options)
    end
  end

end
