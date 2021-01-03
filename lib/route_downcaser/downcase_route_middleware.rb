# frozen_string_literal: true

require "active_support/core_ext/object/blank"
require "active_support/core_ext/string/multibyte"

module RouteDowncaser
  class DowncaseRouteMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      dup._call(env)
    end

    def _call(env)
      request_uri = env['REQUEST_URI']
      path_info = env['PATH_INFO']

      # Don't touch anything, if uri/path is part of exclude_patterns
      return @app.call(env) if excluded?([request_uri, path_info])

      # Downcase request_uri and/or path_info if applicable
      request_uri = downcased_uri(request_uri)
      path_info = downcased_uri(path_info)

      # If redirect configured, then return redirect request,
      # if either request_uri or path_info has changed
      if RouteDowncaser.redirect && env['REQUEST_METHOD'] == 'GET'
        return redirect_header(request_uri) if request_uri.present? && request_uri != env['REQUEST_URI']

        return redirect_header(path_info) if path_info.present? && path_info != env['PATH_INFO']
      end

      env['PATH_INFO'] = path_info.to_s if path_info
      env['REQUEST_URI'] = request_uri.to_s if request_uri

      # Default just move to next chain in Rack callstack
      # calling with downcased uri if needed
      @app.call(env)
    end

    private

    def exclude_patterns_match?(uri)
      uri.match(Regexp.union(RouteDowncaser.exclude_patterns)) if uri && RouteDowncaser.exclude_patterns
    end

    def excluded?(paths)
      paths.any? do |path|
        exclude_patterns_match?(path)
      end
    end

    def downcased_uri(uri)
      return nil unless uri.present?

      if has_querystring?(uri)
        "#{path(uri).mb_chars.downcase}?#{querystring(uri)}"
      else
        path(uri).mb_chars.downcase
      end
    end

    def path(uri)
      uri_items(uri).first
    end

    def querystring(uri)
      uri_items(uri).last
    end

    def has_querystring?(uri)
      uri_items(uri).length > 1
    end

    def uri_items(uri)
      uri.split('?', 2)
    end

    def redirect_header(uri)
      [301, { 'Location' => uri.to_s, 'Content-Type' => 'text/html' }, []]
    end
  end
end
