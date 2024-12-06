# frozen_string_literal: true

require "active_support/core_ext/object/blank"

module RouteDowncaser
  class DowncaseRouteMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      dup._call(env)
    end

    def _call(env)
      path_info = env["PATH_INFO"]

      # Don't touch anything, if path is part of exclude_patterns
      return @app.call(env) if excluded?([path_info])

      # Downcase path_info if applicable
      path_info = downcased_uri(path_info)
      path_info = path_info.gsub("%7E", "~") if path_info

      # If redirect configured, then return redirect request, if either
      # path_info has changed
      if RouteDowncaser.redirect && env["REQUEST_METHOD"] == "GET"
        return redirect_header(path_info) if path_info.present? && path_info != env["PATH_INFO"]
      end

      env["PATH_INFO"] = path_info.to_s if path_info

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
        "#{downcased_path(uri)}?#{querystring(uri)}"
      else
        downcased_path(uri)
      end
    end

    def downcased_path(uri)
      path(uri).split("/").map(&method(:downcase_path_segment)).join("/")
    end

    def downcase_path_segment(segment)
      URI.encode_www_form_component(URI.decode_www_form_component(segment).downcase)
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
      uri.split("?", 2)
    end

    def redirect_header(uri)
      [301, {"Location" => uri.to_s, "Content-Type" => "text/html"}, []]
    end
  end
end
