require 'test_helper'

class MockApp
  attr_accessor :mockenv

  def call(mockenv)
    @mockenv = mockenv.clone
  end
end

class RouteDowncaserTest < ActiveSupport::TestCase

  test "REQUEST_URI path-part is downcased" do
    app = MockApp.new
    callenv = { 'REQUEST_URI' => "HELLO/WORLD" }
    RouteDowncaser::DowncaseRouteMiddleware.new(app).call(callenv)
    assert_equal("hello/world", app.mockenv['REQUEST_URI'])
  end

  test "REQUEST_URI querystring parameters are not touched" do
    app = MockApp.new
    callenv = { 'REQUEST_URI' => "HELLO/WORLD?FOO=BAR" }
    RouteDowncaser::DowncaseRouteMiddleware.new(app).call(callenv)
    assert_equal("hello/world?FOO=BAR", app.mockenv['REQUEST_URI'])
  end

  test "entire PATH_INFO is downcased" do
    app = MockApp.new
    callenv = { 'PATH_INFO' => "HELLO/WORLD" }
    RouteDowncaser::DowncaseRouteMiddleware.new(app).call(callenv)
    assert_equal("hello/world", app.mockenv['PATH_INFO'])
  end

  class ExcludePatternsTests < ActiveSupport::TestCase
    setup do
      @app = MockApp.new
      RouteDowncaser.configuration do |config|
        config.exclude_patterns = [/assets\//i, /fonts\//i]
      end
    end

    test "when PATH_INFO is found in exclude_patterns, do nothing" do
      callenv = { 'PATH_INFO' => "ASSETS/IMAges/SpaceCat.jpeg" }
      RouteDowncaser::DowncaseRouteMiddleware.new(@app).call(callenv)
      assert_equal("ASSETS/IMAges/SpaceCat.jpeg", @app.mockenv['PATH_INFO'])
    end

    test "when REQUEST_URI is found in exclude_patterns, do nothing" do
      callenv = { 'REQUEST_URI' => "ASSETS/IMAges/SpaceCat.jpeg" }
      RouteDowncaser::DowncaseRouteMiddleware.new(@app).call(callenv)
      assert_equal("ASSETS/IMAges/SpaceCat.jpeg", @app.mockenv['REQUEST_URI'])
    end
  end

  class RedirectTrueTests < ActiveSupport::TestCase
    setup do
      @app = MockApp.new
      RouteDowncaser.configuration do |config|
        config.redirect = true
      end
    end

    test "when redirect is true it redirects REQUEST_URI" do
      callenv = { 'REQUEST_URI' => "HELLO/WORLD" }
      assert_equal(
        [301, {'Location' => "hello/world", 'Content-Type' => 'text/html'}, []],
        RouteDowncaser::DowncaseRouteMiddleware.new(@app).call(callenv)
      )
    end

    test "when redirect is true it redirects PATH_INFO" do
      callenv = { 'PATH_INFO' => "HELLO/WORLD" }
      assert_equal(
        [301, {'Location' => "hello/world", 'Content-Type' => 'text/html'}, []],
        RouteDowncaser::DowncaseRouteMiddleware.new(@app).call(callenv)
      )
    end
  end

  class RedirectTrueExcludePatternsTests < ActiveSupport::TestCase
    setup do
      @app = MockApp.new
      RouteDowncaser.configuration do |config|
        config.redirect = true
        config.exclude_patterns = [/assets\//i, /fonts\//i]
      end
    end

    test "when redirect is true it does not redirect, if REQUEST_URI match exclude patterns" do
      callenv = { 'REQUEST_URI' => "fonts/Icons.woff" }
      RouteDowncaser::DowncaseRouteMiddleware.new(@app).call(callenv)
      assert_equal("fonts/Icons.woff", @app.mockenv['REQUEST_URI'])
    end

    test "when redirect is true it does not redirect, if PATH_INFO match exclude patterns" do
      callenv = { 'PATH_INFO' => "fonts/Icons.woff" }
      RouteDowncaser::DowncaseRouteMiddleware.new(@app).call(callenv)
      assert_equal("fonts/Icons.woff", @app.mockenv['PATH_INFO'])
    end
  end

end
