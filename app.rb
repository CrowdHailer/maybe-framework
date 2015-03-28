APP_ROOT = File.expand_path('../', __FILE__)
Dir[APP_ROOT + '/lib/*.rb'].each {|file| require file }

class Sandwitch
  Request = Class.new(Rack::Request)
  Response = Class.new(Rack::Response)
  # Angry reader
  UndefinedRequest = Class.new(StandardError)
  UndefinedRespone = Class.new(StandardError)

  def initialize(app = NotFound)
    @app = app
  end

  attr_reader :app
  attr_writer :request, :response

  def self.call(env)
    new.call(env)
  end

  def response
    @response || (raise UndefinedRespone, 'There is no response object available')
  end

  def request
    @request || (raise UndefinedRequest, 'There is no request object available')
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
