class OoyalaTest < Test::Unit::TestCase
  include Ooyala

  # Ooyala test account
  PARTNER_CODE = 'lsNTrbQBqCQbH-VA6ALCshAHLWrV'
  SECRET_CODE = 'hn-Rw2ZH-YwllUYkklL5Zo_7lWJVkrbShZPb5CD1'

  def setup
    @service = Service.new PARTNER_CODE, SECRET_CODE
  end

  # Test::Unit requires at least one test in a test class
  def default_test
  end

private

  def find_item
    @service.query( :limit => 1 ).items.first
  end

end