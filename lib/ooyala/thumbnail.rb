module Ooyala
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