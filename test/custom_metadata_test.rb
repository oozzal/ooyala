require File.dirname( __FILE__ ) + '/helper'

class CustomMetadataTest < OoyalaTest

  def test_raises_on_invalid_embed_code
    request = CustomMetadataRequest.new( 'cheese' )
    assert_raise( Ooyala::Error ) do
      request.submit( @service )
    end
  end

  def test_sets_single_pair
    request = QueryRequest.new( 'limit' => 1 )
    item = @service.submit( request ).items.first

    embed_code = item.embed_code
    key = 'test_key'
    value = 'test_value'

    request = CustomMetadataRequest.new( embed_code, { key => value } )
    @service.submit request

    request = QueryRequest.new( 'embedCode' => embed_code,
      'limit' => 1,
      'fields' => 'metadata' )

    item = @service.submit( request ).items.first

    assert_equal( value, item.metadata[ key ] )
  end
end