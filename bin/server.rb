require 'rack'

require_relative '../lib/controller_base.rb'
require_relative '../lib/router.rb'
require_relative '../controllers/root_controller.rb'
require_relative '../controllers/books_controller.rb'
require_relative '../controllers/authors_controller.rb'
require_relative '../controllers/sessions_controller.rb'
require_relative '../agile_record/db_connection.rb'


router = Router.new
router.draw do
  get Regexp.new("^/books$"), BooksController, :index
  get Regexp.new("^/?$"), RootController, :root
  get Regexp.new("^/session/new/?$"), SessionsController, :new
  delete Regexp.new("^/session"), SessionsController, :destroy
  get Regexp.new("^/authors/new/?$"), AuthorsController, :new
  post Regexp.new("^/authors$"), AuthorsController, :create
  get Regexp.new("^/books/new/?$"), BooksController, :new
  post Regexp.new("^/books$"), BooksController, :create
  get Regexp.new("^/book/(?<id>\\d+)/edit/?$"), BooksController, :edit
  put Regexp.new("^/books/(?<id>\\d+)"), BooksController, :update
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
