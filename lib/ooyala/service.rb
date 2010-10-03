module Ooyala
  class Service
    HOST = 'api.ooyala.com'
    PORT = 80

    def initialize( partner_code, secret_code )
      @partner_code = partner_code
      @secret_code = secret_code
    end

    def submit( request )
      path = "/partner/#{ path_segment( request ) }"
      query = build_query( request.params )

      http_response = Net::HTTP.start( HOST, PORT ) do |http|
        http.get( "#{ path }?#{ query }" )
      end

      ResponseParser.create( request ).parse http_response
    end

  private

    def path_segment( request )
      case request
      when AttributeUpdateRequest
        'edit'
      when CustomMetadataRequest
        'set_metadata'
      when QueryRequest
        'query'
      when ThumbnailQueryRequest
        'thumbnails'
      else
        raise Error, "Can't get path segment for request of type '#{ request.class.name }'"
      end
    end

    def build_query( params )
      params = params.merge :pcode => @partner_code,
        :signature => sign( params )

      params.collect do |k, v|
        "#{ CGI.escape( k.to_s ) }=#{ CGI.escape( v.to_s ) }"
      end.join( "&" )
    end

    def sign( params )
      unsigned = @secret_code +
        params.keys.sort.collect { |key| "#{ key }=#{ params[ key ] }" }.join

      Base64::encode64( Digest::SHA256.digest( unsigned ) )[ 0, 43 ].
        gsub( /=+$/, '' )
    end
  end
end