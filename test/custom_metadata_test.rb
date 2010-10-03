require File.dirname( __FILE__ ) + '/helper'

class CustomMetadataTest < OoyalaTest

  def test_raises_on_invalid_embed_code
    request = CustomMetadataRequest.new( 'cheese' )
    assert_raise( Ooyala::Error ) do
      request.submit( @account )
    end
  end

  def test_deletes_single
    key, value = 'test_key', 'test_value'
    embed_code = find_item.embed_code

    @client.update_metadata embed_code, key => value
    assert_equal value, @client.find( embed_code ).metadata[ key ]

    CustomMetadataRequest.new( embed_code, {}, [ key ] ).submit( @account )
    assert_nil @client.find( embed_code ).metadata[ key ]
  end

  def test_deletes_multiple
    key1, value1 = 'key1', 'value1'
    key2, value2 = 'key2', 'value2'
    embed_code = find_item.embed_code

    @client.update_metadata embed_code, { key1 => value1, key2 => value2 }
    item = @client.find( embed_code )
    assert_equal value1, item.metadata[ key1 ]
    assert_equal value2, item.metadata[ key2 ]

    CustomMetadataRequest.new( embed_code, {}, [ key1, key2 ] ).submit( @account )
    item = @client.find( embed_code )
    assert_nil item.metadata[ key1 ]
    assert_nil item.metadata[ key2 ]
  end

  def test_sets_single_pair
    key, value = 'test_key', 'test_value'
    embed_code = find_item.embed_code

    CustomMetadataRequest.new( embed_code, key => value ).submit( @account )

    assert_equal value, @client.find( embed_code ).metadata[ key ]
  end

end