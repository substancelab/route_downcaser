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
    env = { 'PATH_INFO' => "ASSETS/IMAges/SpaceCat.jpeg" }
    RouteDowncaser::DowncaseRouteMiddleware.new(app).call(env)

    assert_equal("assets/images/SpaceCat.jpeg", app.env['PATH_INFO'])
  end

  test "urls can be left alone by configuration" do
    app = MockApp.new
    env = { 'PATH_INFO' => "password_resets/aBcDeF/edit" }

    ignore = /^password_resets/
    RouteDowncaser::DowncaseRouteMiddleware.new(app, :ignore => ignore).call(env)

    assert_equal("password_resets/aBcDeF/edit", app.env['PATH_INFO'])
  end

  test "path is still downcased if ignore does not match" do
    app = MockApp.new
    env = { 'PATH_INFO' => "HELLO/WORLD" }

    ignore = /^password_resets/
    RouteDowncaser::DowncaseRouteMiddleware.new(app, :ignore => ignore).call(env)

    assert_equal("hello/world", app.env['PATH_INFO'])
  end
end
