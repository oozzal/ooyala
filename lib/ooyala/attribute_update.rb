module Ooyala
  class AttributeUpdateRequest < Request

    # Embed code of the object to update
    attr_accessor :embed_code

    # Title of video or channel
    attr_accessor :title

    # Description of video or channel
    attr_accessor :description

    # Time at which video or channel becomes available (+Time+)
    attr_accessor :flight_start

    # Time at which video or channel becomes unavailable (+Time+)
    attr_accessor :flight_end

    # Status of video or channel (+:live+, +:paused+, or +:deleted+)
    attr_accessor :status

    # URL used in info panel of player and RSS feed
    attr_accessor :hosted_at

    def initialize( embed_code, attrs = {} )
      attrs.assert_valid_keys :title, :description, :flight_start,
        :flight_end, :status, :hosted_at

      self.embed_code = embed_code

      attrs.each do |k, v|
        send "#{k}=", v
      end
    end

    def status=( value ) # :nodoc:
      unless [ nil, :live, :paused, :deleted ].include?( value )
        raise ArgumentError, "Invalid status: '#{ value }'"
      end
    end

  private

    def params_internal
      {
        'embedCode' => @embed_code,
        'title' => title,
        'description' => description,
        'flightEnd' => flight_end && flight_end.iso8601,
        'flightStart' => flight_start && flight_start.iso8601,
        'status' => status && status.to_s,
        'hostedAt' => hosted_at
      }.reject { |k, v| v.nil? }
    end

  end

  class AttributeUpdateResponse < Response
  end

end