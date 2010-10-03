module Ooyala

  # abstract
  class Request
    include Formatting

    HOST = 'api.ooyala.com'
    PORT = 80

    def submit( account )
      Net::HTTP.start( HOST, PORT ) do |http|
        response_class.parse http.request( prepare( account ) )
      end
    end

  private

    def response_class
      raise NotImplementedError
    end

    def params
      raise NotImplementedError
    end

    def path_segment
      raise NotImplementedError
    end

    def prepare( account )
      Net::HTTP::Get.new "/partner/#{ path_segment }?#{ build_query( account ) }"
    end

    def build_query( account )
      unsigned = params.merge 'expires' => Time.now.to_i + 300

      signed = unsigned.merge :pcode => account.partner_code,
        :signature => Request.sign( unsigned, account )

      signed.collect do |k, v|
        "#{ CGI.escape( k.to_s ) }=#{ CGI.escape( v.to_s ) }"
      end.join( "&" )
    end

    def self.sign( params, account )
      unsigned = account.secret_code +
        params.keys.sort.collect { |key| "#{ key }=#{ params[ key ] }" }.join

      Base64::encode64( Digest::SHA256.digest( unsigned ) )[ 0, 43 ].
        gsub( /=+$/, '' )
    end  

  end
end