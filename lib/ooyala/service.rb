module Ooyala
  class Service
    HOST = 'api.ooyala.com'
    PORT = 80

    def initialize( partner_code, secret_code )
      @partner_code = partner_code
      @secret_code = secret_code
    end

    def submit( request )
      path = "/partner/#{ request.path_segment }"
      query = build_query( request.params )

      http_response = Net::HTTP.start( HOST, PORT ) do |http|
        http.get( "#{ path }?#{ query }" )
      end

      if http_response.is_a?( Net::HTTPServerError )
        raise ServerError
      end

      Response.parse( http_response, request )
    end

  private

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