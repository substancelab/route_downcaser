# frozen_string_literal: true

gem "activesupport"
# require 'active_support/all'
require "route_downcaser"
require "route_downcaser/downcase_route_middleware"
require "route_downcaser/original_downcase_route_middleware"

require "benchmark"

class FakeApp
  def call(env)
  end
end

ITERATIONS = 1_000_000

app = FakeApp.new
original_downcaser = RouteDowncaser::OriginalDowncaseRouteMiddleware.new(app)
optimized_downcaser = RouteDowncaser::DowncaseRouteMiddleware.new(app)

Benchmark.bmbm do |bm|
  # bm.report("Original with small env") do
  #   ITERATIONS.times do
  #     env = {
  #       "PATH_INFO" => "/Here/Or/There",
  #       "REQUEST_URI" => "/Here/Or/There",
  #       "REQUEST_METHOD" => "GET",
  #     }
  #     original_downcaser.call(env)
  #   end
  # end
  bm.report("Original") do
    ITERATIONS.times do
      env = {
        "PATH_INFO" => "/Here/Or/There",
        "REQUEST_URI" => "/Here/Or/There",
        "REQUEST_METHOD" => "GET",
        "GATEWAY_INTERFACE" => "GATEWAY_INTERFACE",
        "HTTP_ACCEPT" => "HTTP_ACCEPT",
        "HTTP_ACCEPT_CHARSET" => "HTTP_ACCEPT_CHARSET",
        "HTTP_ACCEPT_ENCODING" => "HTTP_ACCEPT_ENCODING",
        "HTTP_ACCEPT_LANGUAGE" => "HTTP_ACCEPT_LANGUAGE",
        "HTTP_CACHE_CONTROL" => "HTTP_CACHE_CONTROL",
        "HTTP_CONNECTION" => "HTTP_CONNECTION",
        "HTTP_COOKIE" => "HTTP_COOKIE",
        "HTTP_HOST" => "HTTP_HOST",
        "HTTP_KEEP_ALIVE" => "HTTP_KEEP_ALIVE",
        "HTTP_REFERER" => "HTTP_REFERER",
        "HTTP_USER_AGENT" => "HTTP_USER_AGENT",
        "QUERY_STRING" => "QUERY_STRING",
        "REMOTE_ADDR" => "REMOTE_ADDR",
        "REMOTE_HOST" => "REMOTE_HOST",
        "REMOTE_USER" => "REMOTE_USER",
        "SERVER_NAME" => "SERVER_NAME",
        "SERVER_PORT" => "SERVER_PORT",
        "SERVER_PROTOCOL" => "SERVER_PROTOCOL",
        "SERVER_SOFTWARE" => "SERVER_SOFTWARE"
      }
      original_downcaser.call(env)
    end
  end
  # bm.report("Optimized with small env") do
  #   ITERATIONS.times do
  #     env = {
  #       "PATH_INFO" => "/Here/Or/There",
  #       "REQUEST_URI" => "/Here/Or/There",
  #       "REQUEST_METHOD" => "GET",
  #     }
  #     optimized_downcaser.call(env)
  #   end
  # end
  bm.report("Optimized") do
    ITERATIONS.times do
      env = {
        "PATH_INFO" => "/Here/Or/There",
        "REQUEST_URI" => "/Here/Or/There",
        "REQUEST_METHOD" => "GET",
        "GATEWAY_INTERFACE" => "GATEWAY_INTERFACE",
        "HTTP_ACCEPT" => "HTTP_ACCEPT",
        "HTTP_ACCEPT_CHARSET" => "HTTP_ACCEPT_CHARSET",
        "HTTP_ACCEPT_ENCODING" => "HTTP_ACCEPT_ENCODING",
        "HTTP_ACCEPT_LANGUAGE" => "HTTP_ACCEPT_LANGUAGE",
        "HTTP_CACHE_CONTROL" => "HTTP_CACHE_CONTROL",
        "HTTP_CONNECTION" => "HTTP_CONNECTION",
        "HTTP_COOKIE" => "HTTP_COOKIE",
        "HTTP_HOST" => "HTTP_HOST",
        "HTTP_KEEP_ALIVE" => "HTTP_KEEP_ALIVE",
        "HTTP_REFERER" => "HTTP_REFERER",
        "HTTP_USER_AGENT" => "HTTP_USER_AGENT",
        "QUERY_STRING" => "QUERY_STRING",
        "REMOTE_ADDR" => "REMOTE_ADDR",
        "REMOTE_HOST" => "REMOTE_HOST",
        "REMOTE_USER" => "REMOTE_USER",
        "SERVER_NAME" => "SERVER_NAME",
        "SERVER_PORT" => "SERVER_PORT",
        "SERVER_PROTOCOL" => "SERVER_PROTOCOL",
        "SERVER_SOFTWARE" => "SERVER_SOFTWARE"
      }
      optimized_downcaser.call(env)
    end
  end
end
