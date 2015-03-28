Dir[File.expand_path('../lib/*.rb', __FILE__)].each {|file| require file }
require './lib/sandwitch'

class App < Sandwitch::Controller
  on get do
    response.body = ['Hello World']
  end

  on head do

  end

end
