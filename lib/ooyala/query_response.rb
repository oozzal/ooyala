module Ooyala

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

end