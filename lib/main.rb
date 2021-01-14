require 'uri'
require 'net/http'
require 'json'
require 'ruby-graphviz'
require 'awesome_print'
require 'neatjson'

require_relative 'details'
require_relative 'dispatcher_servlet'
require_relative 'endpoint'
require_relative 'request_mapping_conditions'
require_relative 'some_auth'

ROOT_DIR = File.expand_path('..', __dir__)
prop_file = "#{ROOT_DIR}/resources/properties.conf"
throw Exception.new('No properties file') unless File.exist?(prop_file)
file = File.read(prop_file)
APP_CONF = JSON.parse(file)

def get_token
  url = URI(APP_CONF['URL_BASE'] + APP_CONF['LOGIN_ENDPOINT'])
  http = Net::HTTP.new(url.host, url.port)
  request = Net::HTTP::Post.new(url)
  response = http.request(request)
  token = response['X-CSRF-TOKEN']
  cookie = response['Set-Cookie']

  SomeAuth.new(token, cookie)
end

def get_mappings(menas_auth)
  url = URI(APP_CONF['URL_BASE'] + APP_CONF['MAPPING_ENDPOINT'])
  http = Net::HTTP.new(url.host, url.port)
  request = Net::HTTP::Get.new(url)
  unless menas_auth.nil?
    request['X-CSRF-TOKEN'] = menas_auth.token
    request['Cookie'] = menas_auth.cookie
  end
  response = http.request(request)
  JSON.parse(response.read_body)
end

puts 'Logging in'
menas_auth = APP_CONF['LOGIN_ENDPOINT'] ? get_token : nil
puts 'Logged in'

puts 'Getting mappings'
raw_data = get_mappings(menas_auth)

puts 'Extracting mapping into objects'
selected_endpoints = raw_data
  .dig('contexts','application','mappings','dispatcherServlets','dispatcherServlet')
  .find_all { |h| (h.dig('details', 'handlerMethod', 'className') || '').start_with?(APP_CONF['CLASS_PREFIX']) }
  .map { |ds| DispatcherServlet.new(ds) }

root_endpoint = Endpoint.new('BASE_URL', [''], 0)

selected_endpoints.map do |ds|
  ds.details.request_mapping_conditions.patterns.each do |pattern|
    path = []
    pattern.split(/(?=\/)/).each do |value|
      path << value
      found = root_endpoint.dig(path)
      if found.nil?
        found = Endpoint.new(value, path, path.count('/'))
        root_endpoint.place(path, found)
      end
      if found.request_mapping_conditions.nil? && path.join == pattern
        found.set_conditions(ds.details.request_mapping_conditions)
      end
    end
  end
end

graph = GraphViz.new(:G, type: 'strict digraph', overlap: :scale)
full_graph = root_endpoint.generate_graph(graph, nil)
full_graph.output(png: "#{ROOT_DIR}/output/#{APP_CONF['OUTPUT_FILE_NAME']}")
