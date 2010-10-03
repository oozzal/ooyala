module Ooyala

  class CustomMetadataResponse < Response

    # Success: HTTP 200 with response body:
    #   <?xml version="1.0"?>
    #   <result code="success"/>
    #
    # Failure: HTTP 400 (Bad request) with response body:
    #   <?xml version="1.0"?>
    #   <result code="400 Bad Request" message="Invalid embed code."/>
    #
    def self.parse( http_response )
      case http_response
      when Net::HTTPOK
        CustomMetadataResponse.new
      when Net::HTTPBadRequest
        message = parse_xml( http_response.body ).root[ 'message' ]
        raise Error, message
      else
        raise_unrecognized_response http_response
      end
    end

  end
end