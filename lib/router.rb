class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  # check if route params match the request params
  # note the request has to be formatted
  def matches?(request)
    (http_method == request.request_method.downcase.to_sym) &&
      !!(pattern =~ request.path)
  end

  # use pattern to pull out route params
  # instantiate controller and call controller action
  def run(request, response)
    match_data = @pattern.match(request.path)

    route_params = Hash[match_data.names.zip(match_data.captures)]

    @controller_class
      .new(request, response, route_params)
      .invoke_action(action_name)
  end
end
