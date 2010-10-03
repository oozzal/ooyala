require File.dirname( __FILE__ ) + '/helper'

class QueryTest < OoyalaTest
  def test_returns_one_record_with_limit_set
    request = QueryRequest.new( :limit => 1 )
    response = request.submit( @account )
    assert response.is_a?( QueryResponse )
    assert_equal 1, response.items.count
  end

  def test_raises_on_invalid_page_id
    assert_raise( Ooyala::Error ) do
      QueryRequest.new( :page => -1 ).submit( @account )
    end
  end

  def test_updated_after_reduces_item_count
    cutoff = Time.now - 3600

    response1 = QueryRequest.new.submit( @account )
    response2 = QueryRequest.new( :updated_after => cutoff ).submit( @account )

    assert response1.items.count > response2.items.count
  end
end