class OoyalaTest < Test::Unit::TestCase
  include Ooyala

  def setup
    # Ooyala test account
    @service = Service.new 'lsNTrbQBqCQbH-VA6ALCshAHLWrV',
      'hn-Rw2ZH-YwllUYkklL5Zo_7lWJVkrbShZPb5CD1'
  end

  # Test::Unit requires at least one test in a test class
  def default_test
  end

private

  def find_item
    @service.query( :limit => 1 ).items.first
  end

end