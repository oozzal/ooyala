module Ooyala
  class ThumbnailQueryRequest < Request

    # options
    #   desired_width
    #   desired_height
    #   min_index
    #   max_index

    def initialize( embed_code, options = {} )
      @embed_code = embed_code
      @options = options
    end

    def response_class
      ThumbnailQueryResponse
    end

    def path_segment
      'thumbnails'
    end

  private

    def range_string
      min = @options[ :min_index ] || 0
      max = @options[ :max_index ] || 255
      "#{ min }-#{ max }"
    end

    def resolution_string
      width = @options[ :desired_width ] || 800
      height = @options[ :desired_height ] || 600
      "#{ width }x#{ height }"
    end

    def params_internal
      {
        'embedCode' => @embed_code,
        'range' => range_string,
        'resolution' => resolution_string
      }
    end
  end

  # <thumbnails estimatedWidth="640" requestedWidth="800" embedCode="Rrd2w6PBRFJ7UIRzRv-JlDgfrsjK4TBc" aspectRatio="4/3">
  #   <thumbnail timestamp="0" index="0">http://ak.c.ooyala.com/Rrd2w6PBRFJ7UIRzRv-JlDgfrsjK4TBc/Ut_HKthATH4eww8X5hMDoxOjBrOw-uIx</thumbnail>
  #   <promoThumbnail>http://ak.c.ooyala.com/Rrd2w6PBRFJ7UIRzRv-JlDgfrsjK4TBc/Ut_HKthATH4eww8X5hMDoxOjBrOw-uIx</promoThumbnail>
  # </thumbnails>

  class ThumbnailQueryResponse < Response

    attr_reader :aspect_ratio
    attr_reader :embed_code
    attr_reader :requested_width
    attr_reader :estimated_width
    attr_reader :promo_thumbnail_url
    attr_reader :thumbnails

    def initialize( http_response )
      super

      document = parse_xml( http_response.body )
      element = document.root
      parser = Parser.new( element )

      @aspect_ratio = parser.attr_string( 'aspectRatio' )
      @embed_code = parser.attr_string( 'embedCode' )
      @requested_width = parser.attr_int( 'requestedWidth' )
      @estimated_width = parser.attr_int( 'estimatedWidth' )

      unless ( promo_node = element.at( './promoThumbnail' ) )
        raise ParseError.new( 'No promoThumbnail node found in thumbnail query response' )
      end
      @promo_thumbnail_url = promo_node.content

      @thumbnails = element.xpath( './thumbnail' ).collect do |thumbnail_node|
        Thumbnail.new( thumbnail_node )
      end
    end
  end

  class Thumbnail
    attr_reader :url,
      :timestamp,
      :index

    # <thumbnail timestamp="154466" index="8">http://ak.c.ooyala.com/FzOXU4OkyvK5QLT18dYmC__5FW4u1oB9/hiiSH5uo2s7SFpr35jODoxOjRnO8wIPJ</thumbnail>
    def initialize( element )
      parser = Parser.new( element )
      @url = element.content
      @timestamp = parser.attr_int( 'timestamp' )
      @index = parser.attr_int( 'index' )
    end
  end

end