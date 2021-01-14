class DispatcherServlet
  attr_reader :handler, :predicate, :details

  def initialize(displatcher_servlet)
    @handler = displatcher_servlet['handler']
    @predicate = displatcher_servlet['predicate']
    @details = Details.new(displatcher_servlet['details'])
  end
end
