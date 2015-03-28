require_relative '../../lib/sandwitch'
module HelloWorld
  class App < Sandwitch::Controller
    on get, root do
      response.body = ['Hello, World!']
    end
  end
end

run HelloWorld::App
