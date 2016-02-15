require 'rack'

require_relative '../lib/controller_base.rb'
require_relative '../lib/router.rb'
require_relative '../controllers/root_controller.rb'
require_relative '../controllers/books_controller.rb'
require_relative '../controllers/authors_controller.rb'
require_relative '../controllers/sessions_controller.rb'
require_relative '../active_record/db_connection.rb'

router = Router.new
router.draw do
  get Regexp.new("^/?$"), RootController, :root
end

app = Proc.new do |environment|
  request = Rack::Request.new(environment)
  response = Rack::Response.new
  router.run(request, response)
  response.finish
end

Rack::Server.start(
 app: app,
 Port: 3000
)

# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html
