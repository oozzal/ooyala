require File.dirname( __FILE__ ) + '/helper'

class ThumbnailQueryTest < OoyalaTest

  def test_raises_on_invalid_embed_code
    assert_raise( Ooyala::ItemNotFound ) do
      @service.query_thumbnails 'invalid_embed_code'
    end
  end

  def test_request_returns_promo_and_thumbnails
    item = @service.query( :limit => 1, :content_type => :Video ).items.first

    response = @service.query_thumbnails( item.embed_code )

    assert response.is_a?( ThumbnailQueryResponse )
    assert response.aspect_ratio.is_a? Rational
    assert_equal item.embed_code, response.embed_code
    assert_not_nil response.promo_thumbnail_url

    assert response.thumbnails.is_a?( Array )
    thumbnail = response.thumbnails.first
    assert thumbnail.is_a?( Thumbnail )
    assert_not_nil thumbnail.url
  end

end