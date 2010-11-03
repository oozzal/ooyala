module Ooyala

  class Item

    attr_reader :metadata

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
      :content_type

    def initialize( attrs = {} )
      @metadata = {}
      attrs.each do |k, v|
        send "#{k}=", v
      end
    end
  end

end