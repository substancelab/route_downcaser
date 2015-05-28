require 'test_helper'

class RouteMiddlewareTest < ActionDispatch::IntegrationTest
  test "Middleware is installed and working" do
    RouteDowncaser.configuration do |config|
      config.redirect = false
    end

    get "/HELLO/WORLD"
    assert_response :success
    assert_equal("anybody out there?", @response.body)
  end

  test "Assets are served correctly" do
    RouteDowncaser.configuration do |config|
      config.redirect = false
    end

    get "/assets/application.js"
    assert_response :success
    assert(@response.body.include?("fancy manifest file"))
  end
end
