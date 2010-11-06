module Ooyala
  class QueryRequest < Request

    # Labels; multiple are ANDed
    attr_reader :labels

    # Embed codes
    attr_reader :embed_codes

    # Statuses; zero or more of deleted, live, error, filemissing, uploading,
    # paused, uploaded, na, cremoved, auploading, auploaded, duplicate,
    # pending, and processing
    attr_reader :statuses

    # Time periods for which to return statistics; zero or more of 1d, 2d,
    # 3d, 4d, 5d, 7d, 14d, 28d, 29d, 30d, 31d
    attr_reader :statistics_time_periods

    # :Video, :VideoAd, :Channel, :MultiChannel, :LiveStream, :YouTube, or
    # :RemoteAsset
    attr_accessor :content_type

    # Text in the description
    attr_accessor :description

    # Text in the title
    attr_accessor :title

    # Text in the title or description
    attr_accessor :title_or_description

    # Whether to return lables (default true)
    attr_accessor :return_labels

    # Whether to return metadata (default true)
    attr_accessor :return_metadata

    # Whether to return ratings (default true)
    attr_accessor :return_ratings

    # Whether to return content deleted in the last 30 days (default false)
    attr_accessor :return_deleted

    # Number of results to include per page (default 500)
    attr_accessor :limit

    # Zero-based index of the page to return (default 0)
    attr_accessor :page_id

    # Operator to use when evaluating multiple criteria (+:and+ or +:or+,
    # default +:and+)
    attr_accessor :mode

    # Minimum update time (+Time+)
    attr_accessor :updated_after

    # +:uploaded_at+ or +:updated_at+
    attr_accessor :order_by

    # +:asc+ or +:desc+
    attr_accessor :order_direction

    def initialize( criteria = {} )
      @labels = []
      @embed_codes = []
      @statuses = []
      @statistics_time_periods = []

      @return_labels = true
      @return_metadata = true
      @return_ratings = true
      @return_deleted = false

      [ :content_type, :description, :title, :title_or_description,
        :return_labels, :return_metadata, :return_ratings, :return_deleted,
        :limit, :page_id, :mode, :updated_after ].each do |key|
        if criteria.include?( key )
          send "#{ key }=", criteria[ key ]
        end
      end

      [ :labels, :embed_codes, :statuses, :statistics_time_periods ].each do |key|
        if criteria.include?( key )
          array = send( key )
          array += criteria[ :key ]
        end
      end

      if criteria[ :embed_code ]
        embed_codes << criteria[ :embed_code ]
      end
    end

    def content_type=( value )
      unless [ :Video, :VideoAd, :Channel, :MultiChannel, :LiveStream,
        :YouTube, :RemoteAsset ].include?( value )
        raise ArgumentError, "Invalid content type: '#{ value }'"
      end
      @content_type = value
    end

    def mode=( value )
      unless [ :and, :or ].include?( value )
        raise ArgumentError, "Invalid mode: '#{ value }'"
      end
      @mode = value
    end

    def order_by=( value )
      unless [ :uploaded_at, :updated_at ].include?( value )
        raise ArgumentError, "Invalid order_by: '#{ value }'"
      end
      @order_by = order_by
    end

    def order_direction=( value )
      unless [ :asc, :desc ].include?( value )
        raise ArgumentError, "Invalid order_direction: '#{ value }'"
      end
      @order_direction = value
    end

    def response_class
      QueryResponse
    end

    def path_segment
      'query'
    end

    def params
      params = {
        'contentType' => content_type,
        'description' => description,
        'title' => title,
        'text' => title_or_description,
        'limit' => limit,
        'pageID' => page_id,
        'queryMode' => mode,
        'includeDeleted' => format_bool( return_deleted ),
        'updatedAfter' => updated_after && updated_after.to_i,
        'statistics' => format_list( statistics_time_periods ),
        'status' => format_list( statuses ),
        'embedCode' => format_list( embed_codes ),
        'orderBy' => order_param,
        'fields' => fields_param
      }.reject { |k, v| v.nil? }

      labels.each do |label|
        params[ "label[#{ label }]" ] = ''
      end

      params
    end

  private

    def fields_param
      fields = []
      fields << 'labels' if return_labels
      fields << 'metadata' if return_metadata
      fields << 'ratings' if return_ratings
      format_list fields
    end

    def order_param
      return nil unless order_by && order_direction

      ( order_by == :uploaded_at ? 'uploadedAt' : 'updatedAt' ) +
        ', ' +
        order_direction.to_s
    end

  end
end