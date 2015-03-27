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

  def self.call(env)
    new.call(env)
  end

  def request
    raise UndefinedRequest, 'There is no request object available'
  end

  def new(request, response)
    clone.tap do |copy|

      def copy.request
        request
      end

      def copy.response do
        response
      end
    end
  end

  def call(env)
    new(Request.new(env), Response.new).respond || @app.call(env)
  end

  def respond
    nil
  end

end

class App < Sandwitch
  def respond
    response
  end

  # on get, segment('') do |path|
  #   response.body = 'hello'
  # end


end
