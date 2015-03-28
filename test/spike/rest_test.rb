require_relative '../test_config'
require './rest'

class RestTest < MiniTest::Test
  include Rack::Test::Methods
  def app
    Rest
  end

  def test_get_returns_index
    get '/'
    assert_equal 200, last_response.status
    assert_equal 'Hello World', last_response.body
  end

  def test_delete_index_returns_405
    delete '/'
    assert_equal 405, last_response.status
  end

  def test_options_has_valid_header
    options '/'
    assert_equal 200, last_response.status
    assert_equal "GET\nHEAD", last_response.headers['Allow']
  end
end
