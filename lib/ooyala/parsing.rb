module Ooyala
  module Parsing
    def xml_document?( string )
      string && 0 == string.index( '<?xml' )
    end

    def parse_xml( xml )
      Nokogiri::XML::Document.parse xml
    end

    def parse_string_child( node, child_name )
      child_content node, child_name
    end

    def parse_int_child( node, child_name )
      content = child_content( node, child_name )
      content && parse_int( content )
    end

    def parse_time_child( node, child_name )
      content = child_content( node, child_name )
      content && parse_time( content )
    end

    def parse_string_attr( node, attr_name )
      attr_value node, attr_name
    end

    def parse_int_attr( node, attr_name )
      value = attr_value( node, attr_name )
      value && parse_int( value )
    end

    def parse_int( string )
      string.to_i
    end

    def parse_time( string )
      Time.at string.to_i
    end

    def parse_fraction( string )
      match = /\A(\d+)\/(\d+)\Z/.match( string )
      raise( ParseError, "Can't parse fraction: '#{ string }'" ) unless match
      Rational match[ 1 ].to_i, match[ 2 ].to_i
    end

    def child_content( node, child_name )
      child = node.at( "./#{ child_name }" )
      child && child.content
    end

    def attr_value( node, attr_name )
      node[ attr_name ]
    end

    # "Standard" responses always have HTTP status code 200. The body
    # contains an XML document on success, an error message on failure.
    # This method raises on error, returns the root of a parsed XML document
    # on success.
    #
    def parse_standard_response( http_response )
      unless http_response.is_a?( Net::HTTPOK )
        raise_unrecognized_response http_response
      end

      body = http_response.body

      unless xml_document?( body )
        raise_from_error_string body
      end

      parse_xml( body ).root
    end

    def raise_from_error_string( error_string )
      case error_string
      when 'unknown content'
        raise ItemNotFound
      else
        raise Error, error_string
      end
    end

    def raise_unrecognized_response( http_response )
      raise ParseError, "Unrecognized HTTP response code: '#{ http_response.code }'"
    end
  end
end