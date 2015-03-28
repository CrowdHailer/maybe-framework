require 'awesome_print'

class MiddleWare
  def initialize(app, options={})
    @app = app
  end

  def call(env)
    @app.call(env)
  end
end

class NotFound
  def self.call(env)
    [404, {}, ['Not Found']]
  end
end

class BaseApp
  def self.call(env)
    new.call(env)
  end

  def initialize(app=NotFound)
    @app = app
  end

  def self.on(*args, &action)
    routes << [args, action]
  end

  def self.routes
    @routes ||= []
  end

  def self.get?
    ->(request, env){
      request.get?
    }
  end

  def self.post?
    ->(request, env){
      request.post?
    }
  end

  def self.params(item)
    ->(request, env){
      request.params[item.to_s]
    }
  end

  def self.fin
    ->(request, env){
      request.path_info.match(/\A\/{0,1}\z/)

    }
  end

  def self.segment(pattern='[^\/]+')
    ->(request, env){
      matchdata = request.path_info.match(/\A\/(#{pattern})(\/|\z)/)
      return false unless matchdata
      segment, tail = matchdata.captures
      request.path_info = tail + matchdata.post_match
      # ap tail
      # ap segment
    }
  end

  def call(env)
    request = Rack::Request.new(env)
    self.class.routes.each do |conditions, action|
      # ap conditions
      captures = conditions.map{|part| part.call(request, env)}
      if captures.all?
        return action.call(*captures)
      end
    end
    @app.call(env)
    # @env = env
    # pattern = /3(\d+)/
    # matchdata = env[Rack::PATH_INFO].match(/\A\/(#{pattern})(\/|\z)/)
    # a, *b = matchdata.captures
    # ap req.get?
    # # ap b
    # # ap b.pop
    # request = Rack::Request.new(env)
    # # ap request['hello']
    # # ap env['PATH_INFO']
    #
    # [200, {}, ['hello world']]
  end
end

class App < BaseApp
  on get?, segment, params(:user), fin do |_, segment, user|
    ap "segment #{segment}"
    ap "params #{user}"
    [200, {}, ['about']]
  end
  on post? do |_|
    [200, {}, ['hello post']]
  end
  # on get? do |_|
  #   [200, {}, ['hello worldzz']]
  # end

end

use MiddleWare, :a => 42

run App
