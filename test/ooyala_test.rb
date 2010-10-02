class OoyalaTest < Test::Unit::TestCase
  include Ooyala

  # Ooyala test account
  PARTNER_CODE = 'lsNTrbQBqCQbH-VA6ALCshAHLWrV'
  SECRET_CODE = 'hn-Rw2ZH-YwllUYkklL5Zo_7lWJVkrbShZPb5CD1'

  def setup
    @service = Ooyala::Service.new( PARTNER_CODE, SECRET_CODE )
    @client = Ooyala::Client.new( @service )
  end

  # Test::Unit requires at least one test in a test class
  def default_test
  end

private

  # shortcut
  def submit( request )
    @service.submit( request )
  end

end