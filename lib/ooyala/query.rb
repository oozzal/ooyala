module Ooyala
  class QueryRequest < Request

    def initialize( criteria = {} )
      @criteria = criteria
    end

    def path_segment
      'query'
    end

  private

    def params_internal
      @criteria
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