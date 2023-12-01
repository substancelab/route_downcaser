# frozen_string_literal: true

require "test_helper"

class MyMockApp
  def call(env)
    raise "Env nil" if env.blank?

    @env = env.clone
    @env
  end

  attr_reader :env
end

class RouteDowncaserTest < ActiveSupport::TestCase
  class BasicTests < ActiveSupport::TestCase
    setup do
      @app = MyMockApp.new
      RouteDowncaser.configuration do |config|
        config.redirect = false
        config.exclude_patterns = nil
      end
    end

    test "entire PATH_INFO is downcased" do
      callenv = {"PATH_INFO" => "HELLO/WORLD", "REQUEST_METHOD" => "GET"}
      RouteDowncaser::DowncaseRouteMiddleware.new(@app).call(callenv)
      assert_equal("hello/world", @app.env["PATH_INFO"])
    end

    test "the call environment should always be returned" do
      callenv = {"PATH_INFO" => "/HELLO/WORLD", "REQUEST_METHOD" => "GET"}
      retval = RouteDowncaser::DowncaseRouteMiddleware.new(@app).call(callenv)
      assert_equal({"PATH_INFO" => "/hello/world", "REQUEST_METHOD" => "GET"}, retval)
    end
  end

  class ExcludePatternsTests < ActiveSupport::TestCase
    setup do
      @app = MyMockApp.new
      RouteDowncaser.configuration do |config|
        config.redirect = false
        config.exclude_patterns = [%r{assets/}i, %r{fonts/}i]
      end
    end

    test "when PATH_INFO is found in exclude_patterns, do nothing" do
      callenv = {"PATH_INFO" => "/ASSETS/IMAges/SpaceCat.jpeg", "REQUEST_METHOD" => "GET"}
      RouteDowncaser::DowncaseRouteMiddleware.new(@app).call(callenv)
      assert_equal("/ASSETS/IMAges/SpaceCat.jpeg", @app.env["PATH_INFO"])
    end
  end

  class RedirectTrueTests < ActiveSupport::TestCase
    setup do
      @app = MyMockApp.new
      RouteDowncaser.configuration do |config|
        config.redirect = true
        config.exclude_patterns = nil
      end
    end

    test "when redirect is true it redirects PATH_INFO" do
      callenv = {"PATH_INFO" => "/HELLO/WORLD", "REQUEST_METHOD" => "GET"}
      assert_equal(
        [301, {"Location" => "/hello/world", "Content-Type" => "text/html"}, []],
        RouteDowncaser::DowncaseRouteMiddleware.new(@app).call(callenv)
      )
    end
  end

  class RedirectTrueExcludePatternsTests < ActiveSupport::TestCase
    setup do
      @app = MyMockApp.new
      RouteDowncaser.configuration do |config|
        config.redirect = true
        config.exclude_patterns = [%r{assets/}i, %r{fonts/}i]
      end
    end

    test "when redirect is true it does not redirect, if PATH_INFO match exclude patterns" do
      callenv = {"PATH_INFO" => "/fonts/Icons.woff", "REQUEST_METHOD" => "GET"}
      RouteDowncaser::DowncaseRouteMiddleware.new(@app).call(callenv)
      assert_equal("/fonts/Icons.woff", @app.env["PATH_INFO"])
    end
  end

  class MultibyteTests < ActiveSupport::TestCase
    setup do
      @app = MyMockApp.new
      RouteDowncaser.configuration do |config|
        config.redirect = false
        config.exclude_patterns = nil
      end
    end

    test "Multibyte PATH_INFO is downcased" do
      callenv = {"PATH_INFO" => "/" + URI.encode_www_form_component("ВЕЛОСИПЕД"), "REQUEST_METHOD" => "GET"}
      RouteDowncaser::DowncaseRouteMiddleware.new(@app).call(callenv)
      assert_equal("/" + URI.encode_www_form_component("велосипед"), @app.env["PATH_INFO"])
    end
  end

  class MultibyteRedirectTests < ActiveSupport::TestCase
    setup do
      @app = MyMockApp.new
      RouteDowncaser.configuration do |config|
        config.redirect = true
        config.exclude_patterns = nil
      end
    end

    test "it redirects Multibyte PATH_INFO" do
      callenv = {"PATH_INFO" => "/" + URI.encode_www_form_component("ВЕЛОСИПЕД"), "REQUEST_METHOD" => "GET"}
      RouteDowncaser::DowncaseRouteMiddleware.new(@app).call(callenv)
      result = RouteDowncaser::DowncaseRouteMiddleware.new(@app).call(callenv)
      status, headers = *result

      assert_equal 301, status
      assert_equal "/" + URI.encode_www_form_component("велосипед"), headers["Location"]
      assert_instance_of String, headers["Location"], "Headers must be strings"
    end
  end
end
