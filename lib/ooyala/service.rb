module Ooyala
  class Service

    DEFAULT_HOST = 'api.ooyala.com'

    attr_accessor :partner_code,
      :secret_code,
      :host,
      :port

    # == Options
    # * host
    # * port
    #
    def initialize( partner_code, secret_code, options = {} )
      @partner_code = partner_code
      @secret_code = secret_code
      @host = options[ :host ] || DEFAULT_HOST
      @port = options[ :port ] || Net::HTTP.http_default_port
    end

    # higher-level API; move to QueryItem?
    def find( embed_code )
      query( :embed_code => embed_code ).items.first || raise( ItemNotFound )
    end

    def query( criteria = {} )
      submit QueryRequest.new( criteria )
    end

    def query_thumbnails( embed_code, options = {} )
      submit ThumbnailQueryRequest.new( embed_code, options )
    end

    def update_attributes( embed_code, params )
      submit AttributeUpdateRequest.new( embed_code, params )
    end

    def update_metadata( embed_code, attrs = {}, delete_names = [] )
      submit CustomMetadataRequest.new( embed_code, attrs, delete_names )
    end

  private

    def submit( request )
      response = Net::HTTP.new( host, port ).start do |session|
        session.get build_path( request )
      end

      request.response_class.parse response
    end

    def build_path( request )
      "/partner/#{ request.path_segment }?#{ build_query( request.params ) }"
    end

    def build_query( params )
      unsigned = params.merge 'expires' => Time.now.to_i + 300

      signed = unsigned.merge :pcode => partner_code,
        :signature => sign( unsigned )

      signed.collect do |k, v|
        "#{ CGI.escape( k.to_s ) }=#{ CGI.escape( v.to_s ) }"
      end.join( "&" )
    end

    def sign( params )
      unsigned = secret_code +
        params.keys.sort.collect { |key| "#{ key }=#{ params[ key ] }" }.join

      Base64::encode64( Digest::SHA256.digest( unsigned ) )[ 0, 43 ].
        gsub( /=+$/, '' )
    end  

  end
end