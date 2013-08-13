require 'test_helper'

class MockApp
  attr_accessor :env

  def call(env)
    @env = env
  end
end

class RedirectionTest < ActiveSupport::TestCase
  test "Redirected to REQUEST_URI" do
    app = MockApp.new
    env = { 'REQUEST_URI' => "HELLO/WORLD" }
    RouteDowncaser.redirect = true
    rack_response = RouteDowncaser::DowncaseRouteMiddleware.new(app).call(env)
    assert_equal(rack_response, [301, {"Location" => "hello/world"}, []])
    RouteDowncaser.redirect = false # reset the flag for later tests
  end
end