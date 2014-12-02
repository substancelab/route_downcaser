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

  test "when redirect is set to true it redirects" do
    app = MockApp.new
    env = { 'REQUEST_URI' => "HELLO/WORLD" }
    RouteDowncaser.configuration do |config|
      config.redirect = true
    end

    assert_equal(
      RouteDowncaser::DowncaseRouteMiddleware.new(app).call(env),
      [301, {'Location' => "hello/world", 'Content-Type' => 'text/html'}, []]
    )
  end
end
