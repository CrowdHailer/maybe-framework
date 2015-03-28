require_relative '../test_config'
require './app'

class InitialTest < MiniTest::Test
  include Rack::Test::Methods
  def app
    @app
  end

  def test_returns_404
    @app = Class.new(Sandwitch::Controller)
    get '/'
    assert_equal 404, last_response.status
  end

  def test_app_returns_200
    @app = App
    get '/'
    assert_equal 200, last_response.status
    assert_equal 'Hello World', last_response.body
  end

  def test_no_request_before_dup
    assert_raises AngryAccessor::InstanceVariableError do
      Sandwitch::Controller.new.request
    end
  end

  def test_head_no_body
    @app = App
    head '/'
    assert_equal 200, last_response.status
    assert_equal '', last_response.body
  end

  def test_method_missing_when_no_matcher
    err = assert_raises NoMethodError do
      App.pointless
    end
    # ap err.cause
  end

  # def test_ideal
  #   context = Context.new(mock_request, mock_response)
  #   context.respond
  #
  # end
end
