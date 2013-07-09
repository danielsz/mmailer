class MyCLI < Thor
  desc "hello NAME", "say hello to NAME"

  def hello(name)
    puts "Hello #{name}"
  end

  desc "server", "Start server."

  def server
    Mmailer.start_server
  end

  desc "start FROM", "Start an email run from FROM (default is 0, start of the collection)."
  def start(from=0)
    client(:start)
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


  private

  def client(cmd)
    require 'drb/drb'
    uri = 'druby://localhost:12345'
    begin
      obj = DRbObject.new_with_uri(uri)
      obj.send(cmd)
    rescue DRb::DRbConnError => e
      puts e.message + "\nIs the server running? (You can start the server with)"
    end
  end
end
