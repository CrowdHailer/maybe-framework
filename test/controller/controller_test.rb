require_relative '../test_config'
require './lib/sandwitch'

class InitialTest < MiniTest::Test
  include Rack::Test::Methods
  def app
    @app
  end

  # Integration

  def test_returns_404
    @app = Class.new(Sandwitch::Controller)
    get '/'
    assert_equal 404, last_response.status
  end

  # Instance methods

  def test_initialises_with_app
    controller = Sandwitch::Controller.new :app
    assert_equal :app, controller.app
  end

  def test_can_set_request
    controller = Sandwitch::Controller.new
    controller.request = :request
    assert_equal :request, controller.request
  end

  def test_can_set_response
    controller = Sandwitch::Controller.new
    controller.response = :response
    assert_equal :response, controller.response
  end

  def test_raises_error_when_accessing_with_no_request
    assert_raises AngryAccessor::InstanceVariableError do
      Sandwitch::Controller.new.request
    end
  end

  def test_raises_error_when_accessing_with_no_response
    assert_raises AngryAccessor::InstanceVariableError do
      Sandwitch::Controller.new.response
    end
  end

  def test_method_missing_when_no_matcher
    err = assert_raises NoMethodError do
      Sandwitch::Controller.new.pointless
    end
  end
end
