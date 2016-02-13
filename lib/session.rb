require 'json'

class Session
  # look for cookie and deserialize the cookie into a hash if found
  # or initialize to emtpy hash
  def initialize(request)
    cookie = request.cookies["_rails_lite"]
    if cookie
      @data = JSON.parse(cookie)
    else
      @data = {}
    end
  end

  # helper getter and setter methods
  def [](key)
    @data[key]
  end

  def []=(key, val)
    @data[key] = val
  end

  # serialize the hash into json and save in a cookie
  # send cookie info with response
  def store_session(response)
    cookie = { path: '/', value: @data.to_json }
    response.set_cookie("_rails_lite", cookie)
  end
end
