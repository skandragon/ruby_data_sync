require 'helper'

class TestRubyDataSync < Minitest::Test
  def test_creation_without_arguments
    rds = RubyDataSync.new
    assert rds
  end
end
