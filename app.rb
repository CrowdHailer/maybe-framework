Dir[File.expand_path('../lib/*.rb', __FILE__)].each {|file| require file }

class Sandwitch
  extend AngryAccessor

  class << self
    def call(env)
      new.call(env)
    end

    def on(*args, &action)
      routes << [args, action]
    end

    def routes
      @routes ||= []
    end

    def method_missing(meth, *args, &block)
      begin
        matcher = Matchers.send(meth.capitalize, *args)
        # ->(request){
        #   matcher.new(request).match?
        # }
      rescue NameError
        super
      end
    end
  end

  def initialize(app = NotFound)
    @app = app
  end

  attr_writer :request, :response
  attr_fetcher :request, :response, :app


  def new(request, response)
    clone.tap do |copy|
      copy.request = request
      copy.response = response
    end
  end

  def call(env)
    new(Request.new(env), Response.new).respond || app.call(env)
  end

  def routes
    self.class.routes
  end

  def respond
    routes.each do |conditions, action|
      group_matcher = Matchers.Group(*conditions).new(request)
      # ap group_matcher.match?
      # captures = conditions.map{|part| part.call(request)}
      if group_matcher.match?
        self.instance_exec *[], &action
        return response
      end
    end
    return nil

    routes.each do |matcher, action|
      m = matcher.new(request)
      if m.match_all?
        self.instance_exec *match.captures, &action
      end
    end
  end
end


class App < Sandwitch
  on get do
    response.body = ['Hello World']
  end

  on head do

  end

end
