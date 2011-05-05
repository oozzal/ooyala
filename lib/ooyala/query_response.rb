module Ooyala
  class QueryResponse < Response

    attr_reader :items

    attr_accessor :page_id,
      :next_page_id,
      :size,
      :total_results

    def initialize( attrs = {} )
      @items = []
      attrs.each do |k, v|
        send "#{k}=", v
      end
    end

    class << self

      def parse( http_response )
        el = parse_standard_response( http_response )
        
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
        item = Item.new :embed_code => parse_string_child( el, 'embedCode' ),
          :title => parse_string_child( el, 'title' ),
          :description => parse_string_child( el, 'description' ),
          :status => parse_string_child( el, 'status' ),
          :width => parse_int_child( el, 'width' ),
          :height => parse_int_child( el, 'height' ),
          :size => parse_int_child( el, 'size' ),
          :length => parse_int_child( el, 'length' ),
          :hosted_at => parse_string_child( el, 'hostedAt' ),
          :updated_at => parse_time_child( el, 'updatedAt' ),
          :uploaded_at => parse_time_child(el, 'uploadedAt' ),
          :content_type => parse_string_child( el, 'content_type' )
          
        el.xpath( './metadata/metadataItem' ).each do |el_metadata_item|
          name, value = parse_metadata_item( el_metadata_item )
          item.metadata[ name ] = value
        end
        
        el.xpath( './thumbnail' ).each do |el_thumbnail|
          item.thumbnails << Thumbnail.new( parse_thumbnail_item(el_thumbnail) )
        end
        
        el.xpath( './streams/stream' ).each do |el_stream|
          item.streams << Stream.new( parse_stream_item(el_stream) )
        end
        
        item
      end

      def parse_metadata_item( el )
        [
          parse_string_attr( el, 'name' ),
          parse_string_attr( el, 'value' )
        ]
      end
      
      def parse_thumbnail_item( el )
        {:height => parse_int_attr( el, 'height' ),
         :width => parse_int_attr( el, 'width' ),
         :url => parse_string_child( el, '.' )}
      end
      
      def parse_stream_item( el )
        {:average_video_bitrate => parse_int_attr( el, 'averageVideoBitrate' ),
         :audio_bitrate =>        parse_int_attr( el, 'audioBitrate' ),
         :framerate =>            parse_string_attr( el, 'framerate' ),
         :pixel_aspect_ratio =>   parse_string_attr( el, 'pixelAspectRatio' ),
         :video_codec =>          parse_string_attr( el, 'videoCodec' ),
         :audio_codec =>          parse_string_attr( el, 'audioCodec' ),
         :level =>                parse_string_attr( el, 'level' ),
         :url =>                  parse_string_attr( el, 'url' ),
         :profile =>              parse_string_attr( el, 'profile' ),
         :video_width =>          parse_int_attr( el, 'videoWidth' ),
         :video_height =>         parse_int_attr( el, 'videoHeight' ),
         :iphone_compatible =>    parse_string_attr( el, 'iPhoneCompatible' ),
         :ipad_compatible =>      parse_string_attr( el, 'iPadCompatible' )}
      end

    end

  end
end