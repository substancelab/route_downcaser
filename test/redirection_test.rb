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
    DowncaseRedirector.redirect = true
    rack_response = DowncaseRedirector::DowncaseRedirectorMiddleware.new(app).call(env)
    assert_equal(rack_response, [301, {"Location" => "hello/world", 'Content-Type' => 'text/html'}, []])
    DowncaseRedirector.redirect = false # reset the flag for later tests
  end

  test "A nil REQUEST_URI should not cause an error" do
    app = MockApp.new
    env = { 'REQUEST_URI' => nil }
    DowncaseRedirector.redirect = true
    DowncaseRedirector::DowncaseRedirectorMiddleware.new(app).call(env)
    # if we get this far, no relevant error was raised
    assert_nil(env['REQUEST_URI'])
    DowncaseRedirector.redirect = false # reset the flag for later tests
  end

  test "asset filenames are not touched" do
    app = MockApp.new
    env = { 'PATH_INFO' => "/ASSETS/IMAges/SpaceCat.jpeg" }
    puts env
    DowncaseRedirector.redirect = true
    DowncaseRedirector::DowncaseRedirectorMiddleware.new(app).call(env)
    puts env

    assert_equal("/assets/images/SpaceCat.jpeg", env['PATH_INFO'])
    DowncaseRedirector.redirect = false
  end

end