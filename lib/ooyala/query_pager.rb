module Ooyala

  class QueryPager
    include Enumerable

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

      criteria = @criteria.merge :limit => @page_size,
        :page_id => @page_id

      response = @service.query( criteria )

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

    def each
      reset
      yield succ until eof?
    end

  end
end