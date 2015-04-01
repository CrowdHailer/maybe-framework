require 'awesome_print'

class Base
  def self.new(next_app=->(env){[404, {}, ['Not Found']]})
    Class.new(MiddleWare){
      ap 'new App Class'
      define_singleton_method :new do
        ap 'new App'
        Class.method(:new).unbind.bind(self).call
      end

      define_method :app do
        next_app
      end
    }
  end

  def self.call(env)
    ap self
    new.call(env)
  end

  def call(env)
    raise StandardError
  end

end

class MiddleWare < Base
  def call(env)
    ap 'before'
    app.call(env)

  end
end


App = Base.new
class App
  def initialize
    ap 'initialize app'
  end
  def call(env)
    request = Rack::Request.new(env)
    if request.path_info == '/'
      [200,{}, ['ok']]
    else
      app.call(env)
    end
  end
end



# use MiddleWare
run App
