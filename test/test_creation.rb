require 'helper'

class RubyDataSync::TestEngine < Minitest::Test
  class MyDataSource < RubyDataSync::Datasource
  end

  def test_creation_without_arguments_raises
    assert_raises (ArgumentError) do
      rds = RubyDataSync::Engine.new
    end
  end

  def test_with_valid_args_works
    options = {
      uuid: 'fake-uuid-here',
      datasource: MyDataSource.new,
    }
    rds = RubyDataSync::Engine.new(options)
    assert rds
    assert_equal rds.uuid, 'fake-uuid-here'
    assert_equal rds.datasource.class, MyDataSource
  end
end
