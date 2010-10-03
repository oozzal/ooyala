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
    attr_accessor :page

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
        :limit, :page, :mode, :updated_after ].each do |key|
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

  private

    def params_internal
      params = {
        'contentType' => content_type && content_type.to_s,
        'description' => description,
        'title' => title,
        'text' => title_or_description,
        'embedCode' => comma_list_param( embed_codes ),
        'fields' => fields_param,
        'includeDeleted' => return_deleted ? 'true' : 'false',
        'limit' => limit && limit.to_s,
        'pageID' => page && page.to_s,
        'queryMode' => mode && mode.to_s,
        'statistics' => comma_list_param( statistics_time_periods ),
        'status' => comma_list_param( statuses ),
        'updatedAfter' => updated_after && updated_after.to_i,
        'orderBy' => order_param
      }.reject { |k, v| v.nil? }

      labels.each do |label|
        params[ "label[#{ label }]" ] = ''
      end

      params
    end

    def comma_list_param( array )
      array.empty? ? nil : array.join( ',' )
    end

    def fields_param
      fields = []
      fields << 'labels' if return_labels
      fields << 'metadata' if return_metadata
      fields << 'ratings' if return_ratings
      fields.empty? ? nil : fields.join( ',' )
    end

    def order_param
      return nil unless @order_by && @order_direction
      "#{ @order_by == :uploaded_at ? 'uploadedAt' : 'updatedAt' }, #{ @order_direction }"
    end

  end

  class QueryResponse < Response

    attr_reader :items

    attr_accessor :page_id,
      :next_page_id,
      :size,
      :total_results

    def initialize( attrs = {} )
      @items = []
      attrs.each do |k, v|
        send "#{k}=", v
      end
    end

  end

  class QueryItem

    attr_reader :metadata

    attr_accessor :embed_code,
      :title,
      :description,
      :status,
      :width,
      :height,
      :size,
      :length, # duration
      :hosted_at,
      :updated_at

    def initialize( attrs = {} )
      @metadata = {}
      attrs.each do |k, v|
        send "#{k}=", v
      end
    end
  end

  class QueryPager

    def initialize( service, criteria = {}, page_size = 500 )
      @service = service
      @criteria = criteria
      @page_size = page_size
      reset
    end

    def reset
      @page_id = 0
      @eof = false
    end

    def eof?
      @eof
    end

    def succ
      raise 'EOF' if eof?

      criteria = @criteria.merge 'limit' => @page_size,
        'pageID' => @page_id

      response = QueryRequest.new( criteria ).submit( @service )

      # Ooyala does not return the next page ID when the page size is larger
      # than the recordset size
      if response.next_page_id
        @page_id = response.next_page_id
        @eof = ( @page_id < 0 )
      else
        @eof = true
      end

      response
    end

    def each_page
      raise "No block" unless block_given?
      reset
      yield succ until eof?
    end
  end

  class QueryIterator
    include Enumerable

    def initialize( service, criteria = {} )
      @service = service
      @criteria = criteria
    end

    def each
      QueryPager.new( @service, @criteria, 500 ).each_page do |page|
        page.items.each do |item|
          yield item
        end
      end
    end
  end
end