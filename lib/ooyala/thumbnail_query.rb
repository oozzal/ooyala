module Ooyala
  class ThumbnailQueryRequest < Request

    # Embed code of the object for which to request thumbnails
    attr_accessor :embed_code

    # Together with +max_index+, specifies the range of thumbnails to return
    attr_accessor :min_index

    # Together with +min_index+, specifies the range of thumbnails to return
    attr_accessor :max_index

    # Desired width of the returned thumbnails. Ooyala may return images
    # with a greater width.
    attr_accessor :desired_width

    # Desired height of the returned thumbnails. Ooyala may return images
    # with a greater height.
    attr_accessor :desired_height

    def initialize( embed_code, params = {} )
      params.assert_valid_keys :desired_width, :desired_height, :min_index,
        :max_index

      self.embed_code = embed_code
      self.desired_width = params[ :desired_width ] || 800
      self.desired_height = params[ :desired_height ] || 600
      self.min_index = params[ :min_index ] || 0
      self.max_index = params[ :max_index ] || 255
    end

    def path_segment
      'thumbnails'
    end

  private

    def params_internal
      {
        'embedCode' => embed_code,
        'range' => "#{ min_index }-#{ max_index }",
        'resolution' => "#{ desired_width }x#{ desired_height }"
      }
    end

  end

  class ThumbnailQueryResponse < Response

    attr_reader :thumbnails

    # Embed code of the video from which thumbnails were created
    attr_accessor :embed_code

    # Aspect ratio of thumbnails
    attr_accessor :aspect_ratio

    # URL of the "promo thumbnail," i.e. the one that is displayed in the player
    attr_accessor :promo_thumbnail_url

    attr_accessor :requested_width
    attr_accessor :estimated_width

    def initialize( attrs = {} )
      attrs.assert_valid_keys :embed_code, :aspect_ratio, :requested_width,
        :estimated_width, :promo_thumbnail_url

      @thumbnails = []

      attrs.each do |k, v|
        send "#{k}=", v
      end
    end

  end

  class Thumbnail

    # URL of the thumbnail image
    attr_accessor :url

    # Time in the video, in milliseconds, at which the thumbnail was created
    attr_accessor :timestamp

    # Zero-based index (ordinal) of the thumbnail
    attr_accessor :index

    def initialize( attrs = {} )
      attrs.each do |k, v|
        send "#{k}=", v
      end
    end
  end

end