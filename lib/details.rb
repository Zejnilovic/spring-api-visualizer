class Details
attr_reader :handler_method, :request_mapping_conditions

  def initialize(details)
    @handler_method = details['handler_method']
    @request_mapping_conditions = RequestMappingConditions.new(details['requestMappingConditions'])
  end
end
