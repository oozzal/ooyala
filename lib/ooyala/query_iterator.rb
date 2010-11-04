module Ooyala

  class QueryIterator
    include Enumerable

    def initialize( service, criteria = {} )
      @service = service
      @criteria = criteria
    end

    def each
      QueryPager.new( @service, @criteria ).each do |page|
        page.items.each do |item|
          yield item
        end
      end
    end
  end

end