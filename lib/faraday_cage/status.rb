module FaradayCage
  ##
  # Wraps status codes to provide various helper methods for testing a response.
  #
  # @example Testing whether a status is successful.
  #
  #     status.success?
  #
  # @example Getting a status name.
  #
  #     status.name
  #     # => :service_unavailable
  #
  # @example Comparing a status.
  #
  #     status == 200
  #     # => true
  #
  # @example Converting a status.
  #
  #     status.to_i
  #     # => 422
  #     status.to_sym
  #     # => :unprocessable_entity
  #
  # @example Testing a status by name.
  #
  #     status.forbidden?
  #     # => false
  class Status
    MAPPINGS = {
      100 => :continue,
      101 => :switching_protocols,
      102 => :processing,
      200 => :ok,
      201 => :created,
      202 => :accepted,
      203 => :non_authoritative_information,
      204 => :no_content,
      205 => :reset_content,
      206 => :partial_content,
      207 => :multi_status,
      226 => :im_used,
      300 => :multiple_choices,
      301 => :moved_permanently,
      302 => :found,
      303 => :see_other,
      304 => :not_modified,
      305 => :use_proxy,
      307 => :temporary_redirect,
      400 => :bad_request,
      401 => :unauthorized,
      402 => :payment_required,
      403 => :forbidden,
      404 => :not_found,
      405 => :method_not_allowed,
      406 => :not_acceptable,
      407 => :proxy_authentication_required,
      408 => :request_timeout,
      409 => :conflict,
      410 => :gone,
      411 => :length_required,
      412 => :precondition_failed,
      413 => :request_entity_too_large,
      414 => :request_uri_too_long,
      415 => :unsupported_media_type,
      416 => :requested_range_not_satisfiable,
      417 => :expectation_failed,
      422 => :unprocessable_entity,
      423 => :locked,
      424 => :failed_dependency,
      426 => :upgrade_required,
      500 => :internal_server_error,
      501 => :not_implemented,
      502 => :bad_gateway,
      503 => :service_unavailable,
      504 => :gateway_timeout,
      505 => :http_version_not_supported,
      507 => :insufficient_storage,
      510 => :not_extended
    }

    MAPPINGS.invert.each do |method, code|
      class_eval <<-RUBY
        def #{method.to_s}?
          code == #{code}
        end
      RUBY
    end

    attr_reader :code

    def initialize(code)
      @code = code.to_i
    end

    def ==(object)
      object.respond_to?(:to_i) ? object.to_i == code : super
    end

    def name
      @name ||= MAPPINGS[code]
    end

    def to_i
      code
    end

    def to_s
      name.to_s
    end

    def to_sym
      name
    end

    def inspect
      "#<FaradayCage::Status code: #{code.inspect} name: #{name.inspect}>"
    end

    def type
      @type ||= case code
      when 100..199
        :informational
      when 200..299
        :success
      when 300..399
        :redirect
      when 400..499
        :client_error
      when 500..599
        :server_error
      else
        :unknown
      end
    end

    def informational?
      type == :informational
    end

    def success?
      type == :success
    end

    def redirect?
      type == :redirect
    end

    def client_error?
      type == :client_error
    end

    def server_error?
      type == :server_error
    end

    def error?
      client_error? || server_error?
    end

    def unknown?
      type == :unknown
    end
  end # StatusCode
end # FaradayCage
