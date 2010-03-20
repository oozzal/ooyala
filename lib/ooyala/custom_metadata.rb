module Ooyala
  class CustomMetadataRequest < Request
  
    def initialize( embed_code, pairs = {} )
      @embed_code = embed_code
      @pairs = pairs
    end

    def response_class
      CustomMetadataResponse
    end

    def type
      'set_metadata'
    end  
    
  private

    def params_internal
      @pairs.dup.merge 'embedCode' => @embed_code
    end
  end

  class CustomMetadataResponse < Response
  
    # From Ooyala docs:
    # <?xml version="1.0" encoding="UTF-8"?>
    # <result code="success">ok</result>
    # When the request is successful, "code" will be "success". When the
    # request is unsuccessful, "code" will be an HTTP status code indicating
    # the reason for the failure.

    def initialize( http_response )
      super
      
      element = parse_xml( http_response.body ).root
      
      if 'success' != element.attributes[ 'code' ]
        message = "#{ element.attributes[ 'code' ] }: #{ element.attributes[ 'message' ] }"
        raise Error.new( message )
      end
    end
  end
end