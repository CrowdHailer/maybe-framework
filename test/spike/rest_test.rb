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

  def test_new_returns_page
    get '/new'
    assert_equal 200, last_response.status
  end

  def test_random_page_missing
    get '/random'
    assert_equal 404, last_response.status
  end

  def test_show_uses_id
    get '/3'
    assert_equal 200, last_response.status
    assert_equal '3', last_response.header['X-item-id']
  end
end
