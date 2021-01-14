require 'json'
require 'neatjson'

class RequestMappingConditions
  attr_reader :consumes, :headers, :methods, :params, :patterns, :produces

  def initialize(request_mapping_conditions)
    @consumes = request_mapping_conditions['consumes']
    @headers = request_mapping_conditions['headers']
    @methods = request_mapping_conditions['methods']
    @params = request_mapping_conditions['params']
    @patterns = request_mapping_conditions['patterns']
    @produces = request_mapping_conditions['produces']
    @origin = request_mapping_conditions
  end

  def get_details
    JSON.neat_generate(@origin)
  end
end
