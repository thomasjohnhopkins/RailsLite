require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session.rb'
require_relative './auth_token.rb'
require_relative '../models/author.rb'

class ControllerBase
  attr_reader :request, :response, :params

  # Controller setup
  def initialize(request, response, route_params = {})
    @request, @response = request, response
    @params = route_params.merge(request.params)
    @constructed_response = false
  end

  # Helper method to alias instance variable
  def constructed_response?
    @constructed_response
  end

  # Status code and header for the response
  def redirect_to(url)
    raise "double render error" if constructed_response?

    @response.status = 302
    @response["Location"] = url

    @constructed_response = true

    session.store_session(@response)

    nil
  end

  # Populate the response with content and given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise "double render error" if constructed_response?

    @response.write(content)
    @response['Content-Type'] = content_type

    @constructed_response = true

    session.store_session(@response)

    nil
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    dir_path = File.dirname(__FILE__)
    template_fname = File.join(
      dir_path, "..",
      "views", self.class.to_s.underscore.chomp("_controller"), "#{template_name}.html.erb"
    )

    template_code = File.read(template_fname)

    render_content(
      ERB.new(template_code).result(binding),
      "text/html"
    )
  end

  # checks if there is already a session
  def session
    @session ||= Session.new(@request)
  end

  def flash
    @flash ||= Flash.new(@request)
  end

  def auth_token
    @auth_token ||= AuthToken.new(flash)
  end

  def form_authenticity_token
    auth_token.security
  end

  def current_user
    @current_user ||= Author.where({
      session_token: session["session_token"]
    }).first
  end

  # router calls action_name
  def invoke_action(name)
    self.send(name)
    render(name) unless constructed_response?

    nil
  end


end
