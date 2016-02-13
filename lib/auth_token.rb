require 'json'
require 'webrick'
require 'securerandom'
require_relative './flash'

class AuthToken
  attr_reader :security

  def initialize(flash)
    @security = SecureRandom.urlsafe_base64
    flash[:security] = @security
  end
end
