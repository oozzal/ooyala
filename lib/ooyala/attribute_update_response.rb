module Ooyala

  class AttributeUpdateResponse < Response

    def self.parse( http_response )
      unless http_response.is_a?( Net::HTTPOK )
        raise_unrecognized_response http_response
      end

      unless 'ok' == http_response.body
        raise_from_error_string http_response.body
      end

      AttributeUpdateResponse.new
    end 

  end
end