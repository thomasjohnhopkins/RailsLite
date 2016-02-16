require 'rack'

require_relative '../lib/controller_base.rb'
require_relative '../lib/router.rb'
require_relative '../controllers/root_controller.rb'
# require_relative '../controllers/books_controller.rb'
# require_relative '../controllers/authors_controller.rb'
# require_relative '../controllers/sessions_controller.rb'
# require_relative '../active_record/db_connection.rb'
#
# router = Router.new
# router.draw do
#   get Regexp.new("^/?$"), RootController, :root
# end
#
# app = Proc.new do |environment|
#   request = Rack::Request.new(environment)
#   response = Rack::Response.new
#   router.run(request, response)
#   response.finish
# end
#
# Rack::Server.start(
#  app: app,
#  Port: 3000
# )

# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html

$books = [
  { id: 1, name: "The Boys in the Boat" },
  { id: 2, name: "How to Lose Friends and Alienate People" }
]

# $statuses = [
#   { id: 1, cat_id: 1, text: "Curie loves string!" },
#   { id: 2, cat_id: 2, text: "Markov is mighty!" },
#   { id: 3, cat_id: 1, text: "Curie is cool!" }
# ]

# class StatusesController < ControllerBase
#   def index
#     statuses = $statuses.select do |s|
#       s[:cat_id] == Integer(params['cat_id'])
#     end
#
#     render_content(statuses.to_json, "application/json")
#   end
# end

class Books2Controller < ControllerBase
  def index
    render_content($books.to_json, "application/json")
  end
end

router = Router.new
router.draw do
  get Regexp.new("^/books$"), Books2Controller, :index
  get Regexp.new("^/?$"), RootController, :root
  # get Regexp.new("^/cats/(?<cat_id>\\d+)/statuses$"), StatusesController, :index
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

Rack::Server.start(
 app: app,
 Port: 3000
)
