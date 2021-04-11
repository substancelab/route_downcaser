# frozen_string_literal: true

module RouteDowncaser
  class Railtie < Rails::Railtie
    initializer "add_downcase_route_middleware" do |app|
      app.config.middleware.use RouteDowncaser::DowncaseRouteMiddleware
    end
  end
end
