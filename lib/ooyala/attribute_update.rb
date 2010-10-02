module Ooyala
  class AttributeUpdateRequest < Request

    def initialize( embed_code, params = {} )
      @embed_code = embed_code
      @params = params
    end

    def response_class
      AttributeUpdateResponse
    end

    def path_segment
      'edit'
    end

  private

    def params_internal
      @params.merge 'embedCode' => @embed_code
    end
  end

  class AttributeUpdateResponse < Response

    # Ooyala docs:
    # An update request returns a plain text document containing “ok” on
    # success or error text if an issue is encountered.

    def initialize( http_response )
      body = http_response.body

      unless body && body == 'ok'
        raise Error.new( body )
      end
    end

  end
end