require 'rack'

require_relative '../lib/controller_base.rb'
require_relative '../lib/router.rb'

require_relative '../agile_record/db_connection.rb'


router = Router.new
router.draw do

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
