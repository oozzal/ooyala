require File.dirname( __FILE__ ) + '/helper'

class QueryTest < OoyalaTest
  def test_returns_one_record_with_limit_set
    response = @service.query :limit => 1
    assert response.is_a?( QueryResponse )
    assert_equal 1, response.items.count
  end

  def test_raises_on_invalid_page_id
    assert_raise( Ooyala::Error ) do
      @service.query :page_id => -1
    end
  end

  def test_updated_after_reduces_item_count
    cutoff = Time.now - 3600

    response1 = @service.query
    response2 = @service.query :updated_after => cutoff

    assert response1.items.count > response2.items.count
  end
end