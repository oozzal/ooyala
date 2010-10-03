module Ooyala
  class Service
    HOST = 'api.ooyala.com'
    PORT = 80

    attr_reader :partner_code, :secret_code

    def initialize( partner_code, secret_code )
      @partner_code = partner_code
      @secret_code = secret_code
    end

    def submit( request )
      http_response = Net::HTTP.start( HOST, PORT ) do |http|
        http.request HttpRequestBuilder.create( request, self ).build
      end

      ResponseParser.create( request ).parse http_response
    end
  end
end