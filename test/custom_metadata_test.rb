require File.dirname( __FILE__ ) + '/helper'

class CustomMetadataTest < OoyalaTest

  def test_raises_on_invalid_embed_code
    request = CustomMetadataRequest.new( 'cheese' )
    assert_raise( Ooyala::Error ) do
      request.submit( @service )
    end
  end

  def test_sets_single_pair
    key, value = 'test_key', 'test_value'
    embed_code = find_item.embed_code

    CustomMetadataRequest.new( embed_code, key => value ).submit( @service )

    assert_equal value, @client.find( embed_code ).metadata[ key ]
  end

end