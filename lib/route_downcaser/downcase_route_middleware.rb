module RouteDowncaser
  class DowncaseRouteMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      @env = env

      if env['REQUEST_URI']
        if RouteDowncaser.redirect == true
          if path != path.downcase
            return [301, {'Location' => downcased_uri, 'Content-Type' => 'text/html'}, []]
          end
        else
          env['REQUEST_URI'] = downcased_uri
        end
      end

      # downcase asset names? or downcase PATH_INFO
      if env['PATH_INFO'] =~ /assets\//i
        pieces = env['PATH_INFO'].split('/')
        env['PATH_INFO'] = pieces.slice(0..-2).join('/').downcase + '/' + pieces.last
      elsif env['PATH_INFO']
        env['PATH_INFO'] = env['PATH_INFO'].downcase
      end

      @app.call(env)
    end

    private

    def uri_items
      @env['REQUEST_URI'].split('?')
    end

    def path
      uri_items[0]
    end

    def query?
      uri_items.length > 1
    end

    def downcased_uri
      if query?
        "#{path.downcase!}?#{uri_items[1]}"
      else
        path.downcase!
      end
    end
  end
end
