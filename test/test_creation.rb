require 'helper'

class RubyDataSync::TestEngine < Minitest::Test
  def test_creation_without_arguments
    assert_raises (ArgumentError) do
      rds = RubyDataSync::Engine.new
    end
  end
end
