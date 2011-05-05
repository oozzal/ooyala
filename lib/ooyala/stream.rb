module Ooyala
  
  class Stream
    
    attr_accessor :average_video_bitrate,
      :audio_bitrate,
      :framerate,
      :pixel_aspect_ratio,
      :video_codec,
      :audio_codec,
      :level,
      :url,
      :profile,
      :video_width,
      :video_height,
      :iphone_compatible,
      :ipad_compatible
      
    def initialize( attrs = {} )
      attrs.each do |k, v|
        send "#{k}=", v
      end
    end
    
  end
  
end