module Ooyala

  # abstract
  class Request

    def submit( service )
      service.submit self
    end

    def params
      params = params_internal.dup

      if requires_expiration?
        params[ 'expires' ] ||= Time.now.to_i + 300
      end

      params
    end

  private

    # virtual
    def params_internal
      {}
    end

    # virtual
    def requires_expiration?
      true
    end
  end
end