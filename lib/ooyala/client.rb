module Ooyala
  class Client
    def initialize( account )
      @account = account
    end

    def find( embed_code )
      query( :embed_code => embed_code ).items.first || raise( ItemNotFound )
    end

    def query( criteria )
      QueryRequest.new( criteria ).submit( @account )
    end

    def query_thumbnails( embed_code, options = {} )
      ThumbnailQueryRequest.new( embed_code, options ).submit( @account )
    end

    def update_attributes( embed_code, params )
      AttributeUpdateRequest.new( embed_code, params ).submit( @account )
    end

    def update_metadata( embed_code, attrs = {}, delete_names = [] )
      CustomMetadataRequest.new( embed_code, attrs, delete_names ).submit( @account )
    end
  end
end