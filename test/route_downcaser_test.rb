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

  test "asset filenames are not touched" do
    app = MockApp.new
    env = { 'PATH_INFO' => "assets/images/SpaceCat.jpeg" }
    RouteDowncaser::DowncaseRouteMiddleware.new(app).call(env)

    assert_equal("assets/images/SpaceCat.jpeg", app.env['PATH_INFO'])
  end

  test "asset paths and filenames are not touched" do
    app = MockApp.new
    env = { 'PATH_INFO' => "assets/IMages/SpaceCat.jpeg" }
    RouteDowncaser::DowncaseRouteMiddleware.new(app).call(env)

    assert_equal("assets/IMages/SpaceCat.jpeg", app.env['PATH_INFO'])
  end
end
