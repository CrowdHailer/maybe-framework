class NotFound
  def self.call(env)
    [404, {}, ['Not Found']]
  end
end


class Sandwitch
  def initialize(app = NotFound)
    @app = app
  end

  def self.call(env)
    new.call(env)
  end

  def call(env)
    copy = clone

    copy.define_singleton_method :request do
      Rack::Request.new(env)
    end

    copy.define_singleton_method :response do
      Rack::Response.new
    end

    copy.respond || @app.call(env)
  end

  def respond
    nil
  end

end

class App < Sandwitch
  def respond
    [200, {}, ['about']]
  end
end
