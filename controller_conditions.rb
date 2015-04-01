class App < Sandwitch::Controller
  def get?(request)
    request.get
  end

  def root?
    request.path_info == '/'
  end

  def index?
    get? && root?
  end

  def segment?(pattern='[^\/]+')
    out = request.path_info == pattern
    captures.push out
  end

  def integer?
    segment(/\d+/).to_i
  end

  route Matcher.Get, Matcher.Segment(/\d./), :action => :index
  action :show do |route|
    route.get
    id = route.segment(/\d./)
    [id]
  end

  route :show do |route|
    route.get
    captures << route.segment(/\d+/).to_i
  end

  def show(id)

  end

  def respond
    routes.each do |route, action|
      route.new request.copy
      if route.match
        action.call(*captures)
        return response
      end
    end
  end

  on '//' do
    self.response = app.call(request.env)
  end

  def self.get
    Matcher.get
  end

  def self.extension(file)
    Matcher.Extension(file)
  end

  def on(*matchers, &action)
    matches.map{ |matcher| Matcher.build matcher }
    routes << [Route.new(matchers, action)]
  end

  def mount(*matchers, controller)
    matches.map{ |matcher| Matcher.build matcher }
    # HMMMMM
  end
end
