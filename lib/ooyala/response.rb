module Ooyala

  # abstract
  class Response

    def initialize( http_response )
    end

    class << self
      def parse( http_response, request )
        request.response_class.new( http_response )
      end
    end

  private

    def parse_xml( body )
      unless body && ( 0 == body.index( '<?xml' ) )
        raise Error.new( body )
      end

      Nokogiri::XML::Document.parse( body )
    end

  end
end