module Ooyala

  # abstract
  class Request
    def submit( service )
      service.submit self
    end
  end

end