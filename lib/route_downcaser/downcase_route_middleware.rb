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

      if env['PATH_INFO'] && !(env['PATH_INFO'] =~ /\/assets\//i)
        env['PATH_INFO'] = env['PATH_INFO'].downcase
      end

      @app.call(env)
    end
  end
end
