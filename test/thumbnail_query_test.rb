require File.dirname( __FILE__ ) + '/helper'

class ThumbnailQueryTest < OoyalaTest
  def test_request_returns_promo_and_thumbnails
    item = @client.query( { 'limit' => 1, 'contentType' => 'Video' } ).items.first

    request = ThumbnailQueryRequest.new( item.embed_code )
    response = request.submit( @service )
    
    assert response.is_a?( ThumbnailQueryResponse )
    assert_equal item.embed_code, response.embed_code
    assert_not_nil response.promo_thumbnail_url

    assert response.thumbnails.is_a?( Array )
    thumbnail = response.thumbnails.first
    assert thumbnail.is_a?( Thumbnail )
    assert_not_nil thumbnail.url
  end
end