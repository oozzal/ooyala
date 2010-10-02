module Ooyala
  class Client
    def initialize( ooyala_service )
      @service = ooyala_service
    end

    def find( embed_code )
      query( 'embedCode' => embed_code ).items.first || raise( ItemNotFound )
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

    def update_metadata( embed_code, pairs )
      CustomMetadataRequest.new( embed_code, pairs ).submit( @service )
    end
  end
end