# frozen_string_literal: true

require 'test_helper'

class RouteMiddlewareTest < ActionDispatch::IntegrationTest
  test 'Middleware is installed and working' do
    RouteDowncaser.configuration do |config|
      config.redirect = false
    end

    get '/HELLO/WORLD'
    assert_response :success
    assert_equal('anybody out there?', @response.body)
  end

  test 'Assets are served correctly' do
    RouteDowncaser.configuration do |config|
      config.redirect = false
    end

    get '/assets/application.js'
    assert_response :success
    assert(@response.body.include?('fancy manifest file'))
  end

  test 'Redirect instead of rewrite' do
    RouteDowncaser.configuration do |config|
      config.redirect = true
    end

    get '/HELLO/WORLD'
    assert_equal 301, response.status
    assert_equal '/hello/world', response.location
  end

  test 'Only GET requests should be redirected, POST should rewrite' do
    RouteDowncaser.configuration do |config|
      config.redirect = true
    end

    post '/HELLO/WORLD'
    assert_response :success
    assert_equal('anybody out there?', @response.body)
  end

  test 'Can downcase cyrillic paths correctly' do
    RouteDowncaser.configuration do |config|
      config.redirect = true
    end
    get "/#{URI.encode_www_form_component('ПИВО')}"
    assert_equal 301, response.status
    assert_equal '/пиво', URI.decode_www_form_component(response.location)
  end

  test 'Can downcase longer unicode paths correctly' do
    RouteDowncaser.configuration do |config|
      config.redirect = true
    end
    get "/#{URI.encode_www_form_component('ÃƒÂ¯Ã‚Â¿Ã‚Â½ÃƒÂ¯Ã‚Â¿Ã‚Â½')}"
    assert_equal 301, response.status
    assert_equal '/ãƒâ¯ã‚â¿ã‚â½ãƒâ¯ã‚â¿ã‚â½', URI.decode_www_form_component(response.location)
  end

  test 'Input and output env are the same' do
    class App
      def call(env)
        env
      end
    end

    middleware = RouteDowncaser::DowncaseRouteMiddleware.new(App.new)

    env = {}
    new_env = middleware.call env
    assert(new_env.equal?(env))
  end
end
