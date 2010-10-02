require 'base64'
require 'cgi'
require 'digest/sha2'
require 'net/http'

module Ooyala

  # abstract
  class Request

    def submit( service )
      service.submit self
    end

    def response_class
      raise NotImplementedError
    end

    def params
      params = params_internal.dup

      if requires_expiration?
        params[ 'expires' ] ||= Time.now.to_i + 300
      end

      params
    end

    # the path segment of the request URL, e.g. 'query'
    def path_segment
      raise NotImplementedError
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