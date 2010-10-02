module Ooyala
  class Error < StandardError
  end

  class ItemNotFound < Error
  end

  class ParseError < Error
  end

  class ServerError < Error
  end

end