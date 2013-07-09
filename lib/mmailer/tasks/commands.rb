class MyCLI < Thor
  desc "hello NAME", "say hello to NAME"
  def hello(name)
    puts "Hello #{name}"
  end

  desc "server", "Start server"
  def server
    Mmailer.start_server
  end

  desc "start", "Start an email run"
  def start
    client(:start)
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
