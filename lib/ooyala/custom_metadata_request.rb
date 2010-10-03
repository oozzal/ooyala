module Ooyala
  class CustomMetadataRequest < Request

    # Embed code of the object to update
    attr_accessor :embed_code

    # Name-value pairs of attributes to set (+Hash+)
    attr_accessor :attrs

    # Names of attributes to delete (+Enumerable+)
    attr_accessor :delete_names

    def initialize( embed_code, attrs = {}, delete_names = [] )
      self.embed_code = embed_code
      self.attrs = attrs
      self.delete_names = delete_names
    end

  end

end