require_relative 'route_helpers'


class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
    add_route_helpers
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

  private

    def add_route_helpers
      case action_name
      when :edit
        name = "edit_#{ class_name_singular }"
        add_path_method(name, "/#{ class_name_plural }/:id/edit")
      when :new
        name = "new_#{ class_name_singular }"
        add_path_method(name, "/#{ class_name_plural }/new")
      when :show, :destroy, :update
        name = "#{ class_name_singular }"
        add_path_method(name, "/#{ class_name_plural }/:id")
      when :index, :create
        name = "#{ class_name_plural }"
        add_path_method(name, "/#{ name }")
      end
    end

    def class_name
      controller_class.to_s.underscore.gsub('_controller', '')
    end

    def class_name_plural
      class_name.pluralize
    end

    def class_name_singular
      class_name.singularize
    end

    def add_path_method(name, path)
      path_name = "#{ name }_path"
      puts "#{ path_name } #=> #{ path }"

      RouteHelpers.send(:define_method, path_name) do |*args|
        id = args.first.to_s
          if path.include?(':id') && !id.nil?
            path.gsub!(':id', id)
          end
        path
      end
    end

end


class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(
      pattern,
      method,
      controller_class,
      action_name
    )
  end

  # syntactic sugar to evaluate the proc in the context of the instance
  def draw(&proc)
    instance_eval(&proc)
  end

  # all possible routes
  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  def match(request)
    routes.find { |route| route.matches?(request) }
  end

  # throw 404 if a route match isn't found
  def run(request, response)
    matching_route = match(request)

    if matching_route.nil?
      response.status = 404
    else
      matching_route.run(request, response)
    end
  end
end
