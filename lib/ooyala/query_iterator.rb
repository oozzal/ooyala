module Ooyala

  class QueryIterator
    include Enumerable

    def initialize( account, criteria = {} )
      @account = account
      @criteria = criteria
    end

    def each
      QueryPager.new( @account, @criteria, 500 ).each_page do |page|
        page.items.each do |item|
          yield item
        end
      end
    end
  end

end