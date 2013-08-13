module RouteDowncaser
  class DowncaseRouteMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      if env['REQUEST_URI']
        uri_items = env['REQUEST_URI'].split('?')
        uri_items[0].downcase!
        env['REQUEST_URI'] = uri_items.join('?')
      end

      if env['PATH_INFO'] =~ /assets\//i
        pieces = env['PATH_INFO'].split('/')
        env['PATH_INFO'] = pieces.slice(0..-2).join('/').downcase + '/' + pieces.last
      elsif env['PATH_INFO']
        env['PATH_INFO'] = env['PATH_INFO'].downcase
      end

      if RouteDowncaser.redirect
        [301, {"Location" => env['REQUEST_URI']}, []]
      else
        @app.call(env)
      end
    end
  end
end
