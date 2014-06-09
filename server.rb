require 'socket'                                    # Require socket from Ruby Standard Library (stdlib)

host = 'localhost'
port = 2000

server = TCPServer.open(host, port)                 # Socket to listen to defined host and port
puts "Server started on #{host}:#{port} ..."        # Output to stdout that server started

loop do                                             # Server runs forever
  client = server.accept                            # Wait for a client to connect. Accept returns a TCPSocket

  lines = []
  while (line = client.gets.chomp) && !line.empty?  # Read the request and collect it until it's empty
    lines << line
  end
  puts lines

  filename = lines[0].gsub(/GET \//, '').gsub(/ HTTP.*/, '')

  if File.exists?(filename)
  	client.puts "HTTP/1.1 200 OK\r\n"

  	if filename =~ /.css$/
  		client.puts "Content-type: text/css\r\n\r\n"
  	else
  		client.puts "Content-type: text/html\r\n\r\n"
  	end

  	client.puts File.read(filename)
  else
  	client.puts "HTTP/1.1 404 Not Found\r\n\r\n"
  end                                      # Output the full request to stdout

  # client.puts response

  # client.puts(Time.now.ctime)                       # Output the current time to the client
  client.close                                      # Disconnect from the client
end
