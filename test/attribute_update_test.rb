require File.dirname( __FILE__ ) + '/helper'

class AttributeUpdateTest < OoyalaTest
  
  def test_raises_on_invalid_embed_code
    request = AttributeUpdateRequest.new( 'cheese' )
    assert_raise( Ooyala::Error ) do
      request.submit( @service )
    end
  end
  
  def test_sets_title_and_description
    request = QueryRequest.new( 'limit' => 1 )
    item = @service.submit( request ).items.first
    
    embed_code = item.embed_code
    title = rand( 1000000 ).to_s
    description = rand( 1000000 ).to_s
    hosted_at = "http://example.com/#{ rand( 100000 ) }"
    
    request = AttributeUpdateRequest.new( embed_code, {
      'title' => title,
      'description' => description,
      'hostedAt' => hosted_at } )
      
    @service.submit request
    
    request = QueryRequest.new( 'embedCode' => embed_code, 'limit' => 1 )
    item = @service.submit( request ).items.first
    
    assert_equal( title, item.title )
    assert_equal( description, item.description )
    assert_equal( hosted_at, item.hosted_at )
  end
end