require 'drb/drb'

uri = ARGV.shift
obj = DRbObject.new_with_uri(uri)
obj.up?
rc = obj.up
puts rc
