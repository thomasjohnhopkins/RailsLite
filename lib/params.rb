# require 'uri'

class Params
  def initialize(req, route_params = {})
    @params = route_params.stringify_keys
    # parse_www_encoded_form(req.query_string) if req.query_string
    # parse_www_encoded_form(req.body) if req.body
  end

  def [](key)
    @params[key.to_s]
  end

  def to_s
    @params.to_s
  end

  class AttributeNotFoundError < ArgumentError; end;

  private
  def parse_www_encoded_form(www_encoded_form)
    array = URI::decode_www_form(www_encoded_form)
    array.each do |arr|
      nested_keys = parse_key(arr[0])
      nested_keys.map! { |key| key.to_s }
      key_level = @params
      until nested_keys.length == 1
        new_nest = nested_keys.shift
        key_level[new_nest] ||= {}
        key_level = key_level[new_nest]
      end
      key_level[nested_keys.first] = arr[1]
    end
  end

  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end
end
