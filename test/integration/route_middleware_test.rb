require 'test_helper'
 
class RouteMiddlewareTest < ActionDispatch::IntegrationTest
  test "Middleware is installed and working" do
    get "HELLO/WORLD"
    assert_response 301
  end
end
