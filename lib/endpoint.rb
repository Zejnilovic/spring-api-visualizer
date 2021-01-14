class Endpoint
  attr_reader :name, :path, :request_mapping_conditions, :weight, :parent
  attr_accessor :children

  def initialize(name, path, weight)
    @name = name
    @path = path.join
    @weight = weight
    @children = {}
  end

  def set_conditions(request_mapping_conditions)
    @request_mapping_conditions = request_mapping_conditions
  end

  def set_parent(parent)
    @parent = parent
  end

  def dig(path)
    return self if path.empty?
    return nil if children[path.first].nil?
    children[path.first].dig(path[1..])
  end

  def place(path, endpoint)
    if children[path.first].nil?
      @children[endpoint.name] = endpoint
      endpoint.set_parent(self)
    else
      children[path.first].place(path[1..], endpoint)
    end
  end

  def generate_graph(graph, parent)
    children.each do |_, value|
        value.generate_graph(graph, @path)
    end
    attributes = {}
    # TODO Currently, if I allow xlabels then there is too 
    #       much around and an overlap
    # 
    # unless request_mapping_conditions.nil?
    #     attributes[:xlabel] = request_mapping_conditions.get_details
    # end
    self_node = graph.add_nodes(@path, attributes).label = @name
    graph.add_edges(parent, @path) unless parent.nil?
    graph
  end
end
