require 'xml'

module Ooyala
  class QueryRequest < Request
  
    def initialize( criteria = {} )
      @criteria = criteria
    end

    def response_class
      QueryResponse
    end

    def type
      'query'
    end  
    
  private

    def params_internal
      @criteria
    end
  end

  class QueryResponse < Response

    attr_reader :page_id,
      :next_page_id,
      :size,
      :items
  
    # element: an XML <list/> element
    def initialize( http_response )
      super
      
      document = parse_xml( http_response.body )
      element = document.root

      parser = Parser.new( element )
    
      @page_id = parser.attr_int( 'pageID' )
      @next_page_id = parser.attr_int( 'nextPageID' )
      @size = parser.attr_int( 'size' )
      @total_results = parser.attr_int( 'totalResults' )
      @items = []

      element.find( 'item' ).each do |el_item|
        @items << QueryItem.new( el_item )
      end
    end

  end

  class QueryItem
    attr_reader :embed_code,
      :title,
      :description,
      :status,
      :width,
      :height,
      :size,
      :length, # duration
      :hosted_at,
      :metadata
      
    def initialize( element )
      parser = Parser.new( element )

      @metadata = {}
      @embed_code = parser.string( 'embedCode' )
      @title = parser.string( 'title' )
      @description = parser.string( 'description' )
      @status = parser.string( 'status' )
      @width = parser.int( 'width' )
      @height = parser.int( 'height' )
      @size = parser.int( 'size' )
      @length = parser.int( 'length' )
      @hosted_at = parser.string( 'hostedAt' )
      @updated_at = parser.time( 'updatedAt' )
      
      if ( metadata = element.find_first( 'metadata' ) )
        parse_metadata metadata
      end
    end  
    
  private

    # <metadata>
    #   <metadataItem name="director" value="Francis Ford Coppola"/>
    #   <metadataItem name="actor" value="Marlon Brando"/>
    # </metadata>
      
    def parse_metadata( element )
      element.find( 'metadataItem' ).each do |item|
        @metadata[ item.attributes[ 'name' ] ] = item.attributes[ 'value' ]
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