module DowncaseRedirector
  class DowncaseRedirectorMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      if env['REQUEST_URI']
        uri_items = env['REQUEST_URI'].split('?')
        original_first_uri_item = String.new(uri_items[0])
        if uri_items[0] =~ /^\/?assets\//i
          pieces = env['REQUEST_URI'].split('/')
          env['REQUEST_URI'] = pieces.slice(0..-2).join('/').downcase + '/' + pieces.last
          asset = true
        else
          uri_items[0].downcase!
        end
        changed = !(original_first_uri_item.eql? uri_items[0])
        env['REQUEST_URI'] = uri_items.join('?')
      end

      if env['PATH_INFO'] =~ /^\/?assets\//i
        pieces = env['PATH_INFO'].split('/')
        env['PATH_INFO'] = pieces.slice(0..-2).join('/').downcase + '/' + pieces.last
        asset = true
      elsif env['PATH_INFO']
        env['PATH_INFO'] = env['PATH_INFO'].downcase
      end

      if changed && env['REQUEST_URI'] && (!asset)
        puts "DowncaseRedirectorMiddleware redirecting to #{env['REQUEST_URI']}"
        [301, {'Location' => env['REQUEST_URI'], 'Content-Type' => 'text/html'}, []]
      else
        puts "No DowncaseRedirectorMiddleware redirection"
        @app.call(env)
      end
    end
  end
end
