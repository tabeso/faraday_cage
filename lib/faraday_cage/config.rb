module FaradayCage
  ##
  # Handles configuration of Faraday connection and server options.
  class Config

    ##
    # @return [String]
    #   The URL requests will be made as. Defaults to `http://example.com`.
    attr_accessor :default_host

    attr_writer :app

    def initialize
      self.default_host = 'http://example.com'
    end

    def app
      @app ||= begin
        default_rails_app if defined?(Rails)
      end
    end

    ##
    # Stores and retrieves a proc for building the Faraday connection.
    #
    # @example Defining middleware.
    #     FaradayCage.middleware do |conn|
    #       conn.request :json
    #     end
    #
    # @return [Proc]
    #   Proc for configuring the connection.
    def middleware(&block)
      if block_given?
        @middleware = block
      else
        @middleware
      end
    end

    private

    def default_rails_app
      Rack::Builder.new do
        map '/' do
          run Rails.application
        end
      end.to_app
    end
  end # Config
end # FaradayCage
