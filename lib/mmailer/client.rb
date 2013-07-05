require 'drb/drb'
#uri = ARGV.shift
uri = 'druby://localhost:12345'
obj = DRbObject.new_with_uri(uri)
if obj.up?
  puts "OK, connection with server established"
else
  puts "There was a problem establishing a connection with the server"
end
obj.display_state