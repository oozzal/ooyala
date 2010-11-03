module Ooyala

  # abstract
  class Request
    include Formatting

    def params
      raise NotImplementedError
    end

    def response_class
      raise NotImplementedError
    end

    def path_segment
      raise NotImplementedError
    end

  end
end