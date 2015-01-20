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

  class RedirectTrueTests < ActiveSupport::TestCase
    setup do
      @app = MockApp.new
      RouteDowncaser.configuration do |config|
        config.redirect = true
        config.exclude_patterns = [/assets\//i, /fonts\//i]
      end
    end

    test "when redirect is true it redirects paths that do not contain matching exclude patterns" do
      env = { 'REQUEST_URI' => "HELLO/WORLD" }

      assert_equal(
        RouteDowncaser::DowncaseRouteMiddleware.new(@app).call(env),
        [301, {'Location' => "hello/world", 'Content-Type' => 'text/html'}, []]
      )
    end

    test "when redirect is true it does not redirect matching exclude patterns" do
      env = { 'REQUEST_URI' => "fonts/Icons.woff", 'PATH_INFO' => "fonts/Icons.woff" }

      RouteDowncaser::DowncaseRouteMiddleware.new(@app).call(env)

      assert_equal("fonts/Icons.woff", @app.env['PATH_INFO'])
    end
  end
end
