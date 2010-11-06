require File.dirname( __FILE__ ) + '/helper'

class QueryPagerTest < OoyalaTest

  def test_query_pager_returns_different_records_on_successive_invocations
    pager = QueryPager.new( @service, {}, 1 )

    item1 = pager.succ.items.first
    item2 = pager.succ.items.first

    assert_not_equal item1.embed_code, item2.embed_code
  end

end