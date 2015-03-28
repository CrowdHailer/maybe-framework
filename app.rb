APP_ROOT = File.expand_path('../', __FILE__)
Dir[APP_ROOT + '/lib/*.rb'].each {|file| require file }

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
    matcher = Matchers.const_get(meth.capitalize)
    ->(request){
      matcher.new(request).match?
    }
  end

  def self.root
    ->(request){
      request.path_info == '/'
    }
  end


  def self.segment(pattern='[^\/]+')
    ->(request){
      matchdata = request.path_info.match(/\A\/(#{pattern})(\/|\z)/)
      return false unless matchdata
      segment, tail = matchdata.captures
      request.path_info = tail + matchdata.post_match
      # ap tail
      # ap segment
    }
  end

end


class App < Sandwitch
  on get do
    response.body = ['Hello World']
  end

  # on head do |a|
  #
  # end

end
