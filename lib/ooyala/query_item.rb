module Ooyala

  class QueryItem

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
      :updated_at

    def initialize( attrs = {} )
      @metadata = {}
      attrs.each do |k, v|
        send "#{k}=", v
      end
    end
  end

end