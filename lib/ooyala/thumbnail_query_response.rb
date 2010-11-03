module Ooyala
  class ThumbnailQueryResponse < Response

    attr_reader :thumbnails

    # Embed code of the video from which thumbnails were created
    attr_accessor :embed_code

    # Aspect ratio of thumbnails
    attr_accessor :aspect_ratio

    # URL of the "promo thumbnail," i.e. the one that is displayed in the player
    attr_accessor :promo_thumbnail_url

    # Thumbnail width requested in the query
    attr_accessor :requested_width

    # Ooyala's estimate of the width of the returned thumbnails (?)
    attr_accessor :estimated_width

    def initialize( attrs = {} )
      attrs.assert_valid_keys :embed_code, :aspect_ratio, :requested_width,
        :estimated_width, :promo_thumbnail_url

      @thumbnails = []

      attrs.each do |k, v|
        send "#{k}=", v
      end
    end

    class << self

      def parse( http_response )
        el = parse_standard_response( http_response )

        response = ThumbnailQueryResponse.new :embed_code => parse_string_attr( el, 'embedCode' ),
          :aspect_ratio => parse_fraction( attr_value( el, 'aspectRatio' ) ),
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
end