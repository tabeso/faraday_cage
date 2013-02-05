require 'uri'
require 'net/http'
require 'rack'

require 'faraday_cage/rack_middleware'

module FaradayCage
  class Server

    attr_reader :app

    def initialize(app = FaradayCage.app)
      if app
        @app = app
      else
        raise Error, 'No Rack app configured. Please see documentation for details.'
      end

      @middleware = RackMiddleware.new(app)
    end

    def connection
      @connection ||= Faraday.new(FaradayCage.default_host) do |conn|
        if FaradayCage.middleware.respond_to?(:call)
          FaradayCage.middleware.call(conn)
        end

        conn.adapter :rack, app
      end
    end
  end # Server
end # FaradayCage
