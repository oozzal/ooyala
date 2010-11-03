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

    def response_class
      ThumbnailQueryResponse
    end

    def path_segment
      'thumbnails'
    end

    def params
      {
        'embedCode' => embed_code,
        'range' => "#{ min_index }-#{ max_index }",
        'resolution' => "#{ desired_width }x#{ desired_height }"
      }
    end  

  end
end