module Ooyala
  class CustomMetadataRequest < Request

    # Embed code of the object to update
    attr_accessor :embed_code

    # Name-value pairs of attributes to set (+Hash+)
    attr_accessor :attrs

    def initialize( embed_code, attrs = {} )
      self.embed_code = embed_code
      self.attrs = attrs
    end

  private

    def params_internal
      attrs.merge 'embedCode' => embed_code
    end

  end

  class CustomMetadataResponse < Response
  end
end