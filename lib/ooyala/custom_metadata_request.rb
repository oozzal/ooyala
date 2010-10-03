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

  private

    def response_class
      CustomMetadataResponse
    end

    def path_segment
      'set_metadata'
    end

    def params
      params = attrs.merge 'embedCode' => embed_code

      unless delete_names.empty?
        params[ 'delete' ] = delete_names.join( "\0" )
      end

      params
    end

  end
end