module FaradayCage
  module Response

    def self.extended(base)
      base.instance_eval do
        alias :original_status :status
        def status
          finished? ? Status.new(env[:status]) : nil
        end
      end
    end
  end # Response
end # FaradayCage
