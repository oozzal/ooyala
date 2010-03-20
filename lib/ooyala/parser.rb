module Ooyala
  class Parser
    def initialize( element )
      @element = element
    end
  
    def content( child_name )
      node = @element.find_first( child_name )
      node && node.first && node.first.content
    end

    def string( child_name )
      content child_name
    end
  
    def int( child_name )
      content = content( child_name )
      content && content.to_i
    end

    def time( child_name )
      content = content( child_name )
      content && Time.at( content.to_i )
    end

    def attr_content( attr_name )
      @element.attributes[ attr_name ]
    end

    def attr_int( attr_name )
      content = attr_content( attr_name )
      content && content.to_i
    end
  
    def attr_string( attr_name )
      attr_content attr_name
    end
  end
end