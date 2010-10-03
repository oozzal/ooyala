module Ooyala

  class ResponseParser

    def self.create( request )
      case request
      when AttributeUpdateRequest
        AttributeUpdateResponseParser.new
      when CustomMetadataRequest
        CustomMetadataResponseParser.new
      when QueryRequest
        QueryResponseParser.new
      when ThumbnailQueryRequest
        ThumbnailQueryResponseParser.new
      else
        raise ParseError, "Can't create response parser for request type '#{ request.class.name }'"
      end
    end

    def parse( http_response )
      raise NotImplementedError
    end

  private

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
      parse_int child_content( node, child_name )
    end

    def parse_time_child( node, child_name )
      parse_time child_content( node, child_name )
    end

    def parse_string_attr( node, attr_name )
      attr_value node, attr_name
    end

    def parse_int_attr( node, attr_name )
      parse_int attr_value( node, attr_name )
    end

    def parse_int( string )
      string.to_i
    end

    def parse_time( string )
      Time.at string.to_i
    end

    def child_content( node, child_name )
      child = node.at( "./#{ child_name }" )
      child && child.content
    end

    def attr_value( node, attr_name )
      node[ attr_name ]
    end

    def raise_unrecognized_response( http_response )
      raise ParseError, "Unrecognized HTTP response code: '#{ http_response.code }'"
    end

  end

  class AttributeUpdateResponseParser < ResponseParser

    # =Success
    # HTTP 200, response body "ok"
    #
    # =Failure
    # HTTP 200, response body containing an error message, e.g. "unknown
    # content".
    #
    def parse( http_response )
      case http_response
      when Net::HTTPOK
        case http_response.body
        when 'ok'
          AttributeUpdateResponse.new
        when 'unknown content'
          raise ItemNotFound
        else
          raise Error, http_response.body
        end
      else
        raise_unrecognized_response http_response
      end
    end 
  end

  class CustomMetadataResponseParser < ResponseParser

    # =Success
    # HTTP 200 with response body:
    #   <?xml version="1.0"?>
    #   <result code="success"/>
    #
    # =Failure
    # HTTP 400 (Bad request) with response body:
    #   <?xml version="1.0"?>
    #   <result code="400 Bad Request" message="Invalid embed code."/>
    #
    def parse( http_response )
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

  class QueryResponseParser < ResponseParser

    # = Success
    # HTTP 200 with response body an XML document
    #
    # = Failure
    # HTTP 200 with response body an error string:
    #   Invalid pageID parameter: -1
    #
    def parse( http_response )
      unless http_response.is_a?( Net::HTTPOK )
        raise_unrecognized_response http_response
      end

      unless xml_document?( http_response.body )
        raise Error, http_response.body
      end

      el = parse_xml( http_response.body ).root

      response = QueryResponse.new :page_id => parse_int_attr( el, 'pageID' ),
        :next_page_id => parse_int_attr( el, 'nextPageID' ),
        :size => parse_int_attr( el, 'size' ),
        :total_results => parse_int_attr( el, 'totalResults' )

      el.xpath( './item' ).each do |el_item|
        response.items << parse_query_item( el_item )
      end

      response
    end

  private

    def parse_query_item( el )
      item = QueryItem.new :embed_code => parse_string_child( el, 'embedCode' ),
        :title => parse_string_child( el, 'title' ),
        :description => parse_string_child( el, 'description' ),
        :status => parse_string_child( el, 'status' ),
        :width => parse_int_child( el, 'width' ),
        :height => parse_int_child( el, 'height' ),
        :size => parse_int_child( el, 'size' ),
        :length => parse_int_child( el, 'length' ),
        :hosted_at => parse_string_child( el, 'hostedAt' ),
        :updated_at => parse_time_child( el, 'updatedAt' )

      el.xpath( './metadata/metadataItem' ).each do |el_metadata_item|
        name, value = parse_metadata_item( el_metadata_item )
        item.metadata[ name ] = value
      end

      item
    end

    def parse_metadata_item( el )
      [
        parse_string_attr( el, 'name' ),
        parse_string_attr( el, 'value' )
      ]
    end
  end

  class ThumbnailQueryResponseParser < ResponseParser

    def parse( http_response )
      el = parse_xml( http_response.body ).root

      response = ThumbnailQueryResponse.new :embed_code => parse_string_attr( el, 'embedCode' ),
        :aspect_ratio => parse_string_attr( el, 'aspectRatio' ),
        :requested_width => parse_int_attr( el, 'requestedWidth' ),
        :estimated_width => parse_int_attr( el, 'estimatedWidth' ),
        :promo_thumbnail_url => parse_string_child( el, 'promoThumbnail' )

      el.xpath( './thumbnail' ).each do |el_thumbnail|
        response.thumbnails << parse_thumbnail( el_thumbnail )
      end

      response
    end

  private

    def parse_thumbnail( el )
      Thumbnail.new :url => el.content,
        :timestamp => parse_int_attr( el, 'timestamp' ),
        :index => parse_int_attr( el, 'index' )
    end

  end
end