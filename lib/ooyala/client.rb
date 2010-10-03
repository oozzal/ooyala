module Ooyala
  class Client
    def initialize( ooyala_service )
      @service = ooyala_service
    end

    def find( embed_code )
      query( :embed_code => embed_code ).items.first || raise( ItemNotFound )
    end

    def query( criteria )
      QueryRequest.new( criteria ).submit( @service )
    end

    def query_thumbnails( embed_code, options = {} )
      ThumbnailQueryRequest.new( embed_code, options ).submit( @service )
    end

    def update_attributes( embed_code, params )
      AttributeUpdateRequest.new( embed_code, params ).submit( @service )
    end

    def update_metadata( embed_code, attrs = {}, delete_names = [] )
      CustomMetadataRequest.new( embed_code, attrs, delete_names ).submit( @service )
    end
  end
end