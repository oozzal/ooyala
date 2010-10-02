require File.dirname( __FILE__ ) + '/helper'

class QueryTest < OoyalaTest
  def test_returns_one_record_with_limit_set
    request = QueryRequest.new( 'limit' => 1 )
    response = request.submit( @service )
    assert response.is_a?( QueryResponse )
    assert_equal 1, response.items.count
  end

  def test_raises_on_invalid_page_id
    assert_raise( Ooyala::Error ) do
      QueryRequest.new( 'pageID' => -1 ).submit( @service )
    end
  end

  def test_updated_after_reduces_item_count
    cutoff = Time.now - 3600

    response1 = QueryRequest.new.submit( @service )
    response2 = QueryRequest.new( 'updatedAfter' => cutoff.to_i.to_s ).submit( @service )

    assert response1.items.count > response2.items.count
  end
end