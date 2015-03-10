module RouteDowncaser
  class DowncaseRouteMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      env = env.clone
      if env['REQUEST_URI']
        if RouteDowncaser.redirect == true && !exclude_patterns_match?(env['REQUEST_URI'])
          if path(env) != path(env).downcase
            return [301, {'Location' => downcased_uri(env), 'Content-Type' => 'text/html'}, []]
          end
        else
          env['REQUEST_URI'] = downcased_uri(env)
        end
      end

      if exclude_patterns_match?(env['PATH_INFO'])
        pieces = env['PATH_INFO'].split('/')
        env['PATH_INFO'] = pieces.slice(0..-2).join('/').downcase + '/' + pieces.last
      elsif env['PATH_INFO']
        env['PATH_INFO'] = env['PATH_INFO'].downcase
      end

      @app.call(env)
    end

    private

    def uri_items(env)
      env['REQUEST_URI'].split('?')
    end

    def path(env)
      uri_items(env).first
    end

    def querystring?(env)
      uri_items(env).length > 1
    end

    def downcased_uri(env)
      if querystring?(env)
        "#{path(env).downcase!}?#{uri_items(env)[1]}"
      else
        path(env).downcase!
      end
    end

    def exclude_patterns_match?(uri)
      uri.match(Regexp.union(RouteDowncaser.exclude_patterns)) if uri
    end
  end
end
