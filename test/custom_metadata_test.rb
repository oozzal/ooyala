require File.dirname( __FILE__ ) + '/helper'

class CustomMetadataTest < OoyalaTest

  def test_raises_on_invalid_embed_code
    assert_raise( Ooyala::Error ) do
      @service.update_metadata 'cheese'
    end
  end

  def test_deletes_single
    key, value = 'test_key', 'test_value'
    embed_code = find_item.embed_code

    @service.update_metadata embed_code, key => value
    assert_equal value, @service.find( embed_code ).metadata[ key ]

    @service.update_metadata embed_code, {}, [ key ]
    assert_nil @service.find( embed_code ).metadata[ key ]
  end

  def test_deletes_multiple
    key1, value1 = 'key1', 'value1'
    key2, value2 = 'key2', 'value2'
    embed_code = find_item.embed_code

    @service.update_metadata embed_code, { key1 => value1, key2 => value2 }
    item = @service.find( embed_code )
    assert_equal value1, item.metadata[ key1 ]
    assert_equal value2, item.metadata[ key2 ]

    @service.update_metadata embed_code, {}, [ key1, key2 ]
    item = @service.find( embed_code )
    assert_nil item.metadata[ key1 ]
    assert_nil item.metadata[ key2 ]
  end

  def test_sets_single_pair
    key, value = 'test_key', 'test_value'
    embed_code = find_item.embed_code

    @service.update_metadata embed_code, key => value

    assert_equal value, @service.find( embed_code ).metadata[ key ]
  end

end