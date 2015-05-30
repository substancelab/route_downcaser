module RouteDowncaser
  class Railtie < Rails::Railtie
    initializer "add_downcase_route_middleware" do |app|
      # For some reason, RouteDowncaser needs to be inserted before Devise/Warden, if Devise is used
      # But since it is not possible to test for the presence of a specific middleware module,
      # we instead insert RouteDowncaser before a middleware module, that a) is always present
      # and b) is inserted before Devise/Warden is
      app.config.middleware.insert_before 'Rack::Head', 'RouteDowncaser::DowncaseRouteMiddleware'
    end
  end
end

