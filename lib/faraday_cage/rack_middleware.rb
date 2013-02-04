module FaradayCage
  ##
  # Wraps Rack apps to allow identification when running multiple.
  class RackMiddleware

    attr_reader :app

    def initialize(app)
      @app = app
    end

    def call(env)
      identity_request?(env) ? identity : app.call(env)
    end

    protected

    def identity_request?(env)
      env['PATH_INFO'] == '/__identify__'
    end

    def identity
      [200, { 'Content-Type' => 'text/plain' }, [@app.object_id.to_s]]
    end
  end # Middleware
end # FaradayCage
