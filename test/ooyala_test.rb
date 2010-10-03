class OoyalaTest < Test::Unit::TestCase
  include Ooyala

  # Ooyala test account
  PARTNER_CODE = 'lsNTrbQBqCQbH-VA6ALCshAHLWrV'
  SECRET_CODE = 'hn-Rw2ZH-YwllUYkklL5Zo_7lWJVkrbShZPb5CD1'

  def setup
    @account = Account.new( PARTNER_CODE, SECRET_CODE )
    @client = Client.new( @account )
  end

  # Test::Unit requires at least one test in a test class
  def default_test
  end

private

  def find_item
    @client.query( :limit => 1 ).items.first
  end

end