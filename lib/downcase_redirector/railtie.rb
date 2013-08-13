module DowncaseRedirector
  class Railtie < Rails::Railtie
    initializer "add_downcase_redirector_middleware" do |app|
      app.config.middleware.use "DowncaseRedirector::DowncaseRedirectorMiddleware"
    end
  end
end

