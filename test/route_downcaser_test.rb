require 'test_helper'

class MockApp
  attr_accessor :env

  def call(env)
    @env = env
  end
end

class RouteDowncaserTest < ActiveSupport::TestCase
  test "REQUEST_URI path-part is downcased" do
    app = MockApp.new
    env = { 'REQUEST_URI' => "HELLO/WORLD" }
    RouteDowncaser::DowncaseRouteMiddleware.new(app).call(env)

    assert_equal("hello/world", app.env['REQUEST_URI'])
  end

  test "REQUEST_URI querystring parameters are not touched" do
    app = MockApp.new
    env = { 'REQUEST_URI' => "HELLO/WORLD?FOO=BAR" }
    RouteDowncaser::DowncaseRouteMiddleware.new(app).call(env)

    assert_equal("hello/world?FOO=BAR", app.env['REQUEST_URI'])
  end

  test "entire PATH_INFO is downcased" do
    app = MockApp.new
    env = { 'PATH_INFO' => "HELLO/WORLD" }
    RouteDowncaser::DowncaseRouteMiddleware.new(app).call(env)

    assert_equal("hello/world", app.env['PATH_INFO'])
  end
end
