module Ooyala

  class Item

    attr_reader :metadata
    attr_reader :thumbnails
    attr_reader :streams

    attr_accessor :embed_code,
      :title,
      :description,
      :status,
      :width,
      :height,
      :size,
      :length, # duration
      :hosted_at,
      :updated_at,
      :uploaded_at,
      :content_type

    def initialize( attrs = {} )
      @metadata = {}
      @thumbnails = []
      @streams = []
      attrs.each do |k, v|
        send "#{k}=", v
      end
    end
  end

end