module RouteDowncaser
  class DowncaseRouteMiddleware
    def initialize(app, options = {})
      @app = app
      @options = options
    end

    def call(env)
      downcase_for_rails23(env)
      downcase_for_rails3(env)

      @app.call(env)
    end

    private

    def ignore?(path)
      if path && @options[:ignore]
        path.match @options[:ignore]
      end
    end

    def downcase_for_rails23(env)
      return if ignore? env['REQUEST_URI']

      if env['REQUEST_URI']
        uri_items = env['REQUEST_URI'].split('?')
        uri_items[0].downcase!
        env['REQUEST_URI'] = uri_items.join('?')
      end
    end

    def downcase_for_rails3(env)
      return if ignore? env['PATH_INFO']

      if env['PATH_INFO'] =~ /assets\//i
        pieces = env['PATH_INFO'].split('/')
        env['PATH_INFO'] = pieces.slice(0..-2).join('/').downcase + '/' + pieces.last
      elsif env['PATH_INFO']
        env['PATH_INFO'] = env['PATH_INFO'].downcase
      end
    end


  end
end
