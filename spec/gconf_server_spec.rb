require './a'
require 'test/unit'
require 'rack/test'

class MyAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    MyApp
  end

  def test_my_default
    get '/'
    assert_equal 'hello', last_response.body
  end

end
