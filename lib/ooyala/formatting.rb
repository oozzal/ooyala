module Ooyala
  module Formatting
    def format_time( time )
      time.iso8601
    end

    def format_list( array )
      array.empty? ? nil : array.join( ',' )
    end

    def format_bool( bool )
      bool ? 'true' : 'false'
    end
  end
end