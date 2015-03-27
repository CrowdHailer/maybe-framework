require_relative '../test_config'
require './app'

class InitialTest < MiniTest::Test
  include Rack::Test::Methods
  def app
    @app
  end

  def test_returns_404
    @app = Class.new(Sandwitch)
    get '/'
    assert_equal 404, last_response.status
  end

  def test_app_returns_200
    @app = App
    get '/'
    assert_equal 200, last_response.status
  end
end
