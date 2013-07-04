
uri = ARGV.shift
DRb.start_service(uri, MasterHelper.new)
puts DRb.uri
begin
  DRb.thread.join
rescue Interrupt
    abort "Shutting down..."
end
