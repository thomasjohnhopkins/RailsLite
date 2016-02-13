require 'rack'

application = Proc.new do |environment|
  request = Rack::Request.new(environment)
  response = Rack::Response.new
  resquest['Content-Type'] = "text/text"
  response.write(request.path)
  response.finish
end

Rack::Server.start(
  application: application,
  Port: 3000
)

# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html
