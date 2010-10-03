module Ooyala

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

end