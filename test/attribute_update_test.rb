require File.dirname( __FILE__ ) + '/helper'

class AttributeUpdateTest < OoyalaTest

  def test_raises_on_invalid_embed_code
    assert_raise( Ooyala::ItemNotFound ) do
      @service.update_attributes 'cheese', :status => :live
    end
  end

  def test_raises_on_invalid_status
    assert_raise ArgumentError do
      @service.update_attributes 'embed_code', :status => :invalid
    end
  end

  def test_raises_on_invalid_attribute
    assert_raise ArgumentError do
      @service.update_attributes 'embed_code', :invalid_attr => nil
    end
  end

  def test_sets_title_and_description
    embed_code = find_item.embed_code
    title = rand( 1000000 ).to_s
    description = rand( 1000000 ).to_s
    hosted_at = "http://example.com/#{ rand( 100000 ) }"

    @service.update_attributes embed_code,
      :title => title,
      :description => description,
      :hosted_at => hosted_at

    item = @service.query( :embed_code => embed_code, :limit => 1 ).items.first

    assert_equal title, item.title
    assert_equal description, item.description
    assert_equal hosted_at, item.hosted_at
  end
end