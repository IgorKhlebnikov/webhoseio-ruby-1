require 'net/http'
require 'uri'
require 'json'

class Webhoseio
  attr_reader :token

  BASE_URL = URI.parse('http://webhose.io/').freeze

  def initialize(token)
    @token = token.dup.freeze
    @next_end_point = nil
  end

  def query(end_point, params = {})
    params.update(token: token, format: 'json')
    uri = BASE_URL + end_point
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(uri)
    response.error! if response.code != '200'

    output = JSON.load(response.body)
    @next_end_point = output['next']
    output
  end

  def get_next
    query(@next_end_point)
  end
end
