module FaradayCage
  module Helpers

    %w(get head post put patch delete).each do |method|
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{method}(uri = nil, params_or_body = nil, headers = nil, &block)
          @last_response = FaradayCage.connection.#{method}(uri, params_or_body, headers, &block).tap do |res|
            res.extend(FaradayCage::Response)
          end
        end
      RUBY
    end

    def params(hash)
      FaradayCage.connection.params = hash
    end

    def headers(hash)
      FaradayCage.connection.headers = hash
    end

    def header(name, value)
      FaradayCage.connection.headers[name] = value
    end

    def basic_auth(login, pass = nil)
      FaradayCage.connection.basic_auth(login, pass)
    end

    def token_auth(login, options = nil)
      FaradayCage.connection.token_auth(token, options)
    end

    def last_response
      @last_response || raise(FaradayCage::Error , 'No response yet. Request a page first.')
    end

    def response_headers
      last_response.headers
    end

    def body
      last_response.body
    end

    def source
      last_response.env[:raw_body] || last_response.body
    end

    def reset_faraday_cage!
      FaradayCage.reset!
      @last_response = nil
    end
  end # Helpers
end # FaradayCage
