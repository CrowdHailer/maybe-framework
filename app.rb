class NotFound
  def self.call(env)
    [404, {}, ['Not Found']]
  end
end


class Sandwitch
  Request = Class.new(Rack::Request)
  Response = Class.new(Rack::Response)
  UndefinedRequest = Class.new(StandardError)

  def initialize(app = NotFound)
    @app = app
  end

  attr_reader :app

  def self.call(env)
    new.call(env)
  end

  def request
    raise UndefinedRequest, 'There is no request object available'
  end

  def new(request, response)
    clone.tap do |copy|

      copy.define_singleton_method :request do
        request
      end

      copy.define_singleton_method :response do
        response
      end
    end
  end

  def call(env)
    new(Request.new(env), Response.new).respond || app.call(env)
  end

  def respond
    # ap self.class.routes
    self.class.routes.each do |conditions, action|
      captures = conditions.map{|part| part.call(request)}
      if captures.all?
        self.instance_exec *captures, &action
        return response
      end
    end
    return nil
  end

  def self.on(*args, &action)
    routes << [args, action]
  end

  def self.routes
    @routes ||= []
  end

  def self.get?
    ->(request){
      request.get?
    }
  end

end

class App < Sandwitch
  on get? do |a|
    response.body = ['Hello World']
  end

end

class Rest < Sandwitch

end
