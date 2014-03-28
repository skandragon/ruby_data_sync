require 'helper'

class RubyDataSync::TestEngine < Minitest::Test
  def test_creation_without_arguments_raises
    assert_raises (ArgumentError) do
      rds = RubyDataSync::Engine.new
    end
  end

  def test_with_valid_args_works
    rds = RubyDataSync::Engine.new(uuid: 'fake-uuid-here')
    assert rds
  end
end
