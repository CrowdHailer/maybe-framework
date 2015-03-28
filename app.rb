Dir[File.expand_path('../lib/*.rb', __FILE__)].each {|file| require file }

class Sandwitch
  extend AngryAccessor

  def initialize(app = NotFound)
    @app = app
  end

  attr_writer :request, :response
  attr_fetcher :request, :response, :app

  def self.call(env)
    new.call(env)
  end

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
      captures = conditions.map{|part| part.call(request)}
      if captures.all?
        self.instance_exec *captures, &action
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

  def self.on(*args, &action)
    routes << [args, action]
  end

  def self.routes
    @routes ||= []
  end

  def self.method_missing(meth, *args, &block)
    begin
      matcher = Matchers.send(meth.capitalize)
      ->(request){
        matcher.new(request).match?
      }
    rescue NameError
      super
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
