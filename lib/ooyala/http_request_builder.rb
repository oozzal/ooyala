module Ooyala

  class HttpRequestBuilder

    attr_accessor :request, :service

    def initialize( request, service )
      @request, @service = request, service
    end

    def self.create( request, service )
      klass = case request
      when AttributeUpdateRequest
        AttributeUpdateHttpRequestBuilder
      when CustomMetadataRequest
        CustomMetadataHttpRequestBuilder
      when QueryRequest
        QueryHttpRequestBuilder
      when ThumbnailQueryRequest
        ThumbnailQueryHttpRequestBuilder
      else
        raise "Unrecognized request type: '#{ request.class.name }'"
      end

      klass.new request, service
    end

    def build
      Net::HTTP::Get.new "/partner/#{ path_segment }?#{ query }"
    end

  private

    def query
      unsigned = params.merge 'expires' => Time.now.to_i + 300

      signed = unsigned.merge :pcode => @service.partner_code,
        :signature => sign( unsigned )

      signed.collect do |k, v|
        "#{ CGI.escape( k.to_s ) }=#{ CGI.escape( v.to_s ) }"
      end.join( "&" )
    end

    def sign( params )
      unsigned = @service.secret_code +
        params.keys.sort.collect { |key| "#{ key }=#{ params[ key ] }" }.join

      Base64::encode64( Digest::SHA256.digest( unsigned ) )[ 0, 43 ].
        gsub( /=+$/, '' )
    end  

    def params
      raise NotImplementedError
    end

    def path_segment
      raise NotImplementedError
    end

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


  class AttributeUpdateHttpRequestBuilder < HttpRequestBuilder
  private

    def path_segment
      'edit'
    end

    def params
      {
        'embedCode' => request.embed_code,
        'title' => request.title,
        'description' => request.description,
        'flightEnd' => request.flight_end && format_time( request.flight_end ),
        'flightStart' => request.flight_start && format_time( request.flight_start ),
        'status' => request.status && request.status.to_s,
        'hostedAt' => request.hosted_at
      }.reject { |k, v| v.nil? }
    end
  end


  class CustomMetadataHttpRequestBuilder < HttpRequestBuilder
  private

    def path_segment
      'set_metadata'
    end

    def params
      params = request.attrs.merge 'embedCode' => request.embed_code

      unless request.delete_names.empty?
        params[ 'delete' ] = request.delete_names.join( "\0" )
      end

      params
    end
  end


  class ThumbnailQueryHttpRequestBuilder < HttpRequestBuilder
  private

    def path_segment
      'thumbnails'
    end

    def params
      {
        'embedCode' => request.embed_code,
        'range' => "#{ request.min_index }-#{ request.max_index }",
        'resolution' => "#{ request.desired_width }x#{ request.desired_height }"
      }
    end
  end


  class QueryHttpRequestBuilder < HttpRequestBuilder
  private

    def path_segment
      'query'
    end

    def params
      params = {
        'contentType' => request.content_type,
        'description' => request.description,
        'title' => request.title,
        'text' => request.title_or_description,
        'limit' => request.limit,
        'pageID' => request.page,
        'queryMode' => request.mode,
        'includeDeleted' => format_bool( request.return_deleted ),
        'updatedAfter' => request.updated_after && request.updated_after.to_i,
        'statistics' => format_list( request.statistics_time_periods ),
        'status' => format_list( request.statuses ),
        'embedCode' => format_list( request.embed_codes ),
        'orderBy' => order_param,
        'fields' => fields_param
      }.reject { |k, v| v.nil? }

      request.labels.each do |label|
        params[ "label[#{ label }]" ] = ''
      end

      params
    end

    def fields_param
      fields = []
      fields << 'labels' if request.return_labels
      fields << 'metadata' if request.return_metadata
      fields << 'ratings' if request.return_ratings
      format_list fields
    end

    def order_param
      return nil unless request.order_by && request.order_direction

      ( request.order_by == :uploaded_at ? 'uploadedAt' : 'updatedAt' ) +
        ', ' +
        request.order_direction.to_s
    end
  end

end
