class MyCLI < Thor
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
    require 'mmailer'
    puts Mmailer::VERSION
  end

  private

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
