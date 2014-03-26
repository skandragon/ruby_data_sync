require 'helper'

class TestRubyDataSync < Minitest::Test
  def test_creation_without_arguments
    RubyDataSync = RubyDataSync.new
    assert RubyDataSync
  end
end
