require 'helper'

class RubyDataSync::MemoryDatasource::TestItem < Minitest::Test
  def test_new
    item = RubyDataSync::MemoryDatasource::Item.new('flarg')
    assert_equal 'flarg', item.name
    assert item.uuid
    assert_operator 0, :<, item.created_at
    assert_operator 0, :<, item.modified_at
    assert_equal item.created_at, item.modified_at
    assert_equal 0, item.synced_at
  end
end

class RubyDataSync::MemoryDatasource::TestDeletedItem < Minitest::Test
  def test_new
    item = RubyDataSync::MemoryDatasource::Item.new('flarg')
    deleted = RubyDataSync::MemoryDatasource::DeletedItem.new(item)
    assert_equal item.uuid, deleted.uuid
    assert_operator 0, :<, deleted.deleted_at
  end
end

class RubyDataSync::TestMemoryDatasource < Minitest::Test
  def test_create_item
    ds = RubyDataSync::MemoryDatasource.new
    ds.create_item
    assert_equal ds.items.count, 1
  end

  def test_delete_item
    ds = RubyDataSync::MemoryDatasource.new
    ds.create_item
    item = ds.items.first
    ds.delete_item
    assert_equal ds.items.count, 0
    assert_equal ds.deleted_items.count, 1
    assert_equal ds.deleted_items[0].uuid, item.uuid
  end

  def test_items_modified
    ds = RubyDataSync::MemoryDatasource.new

    target_count = 20

    target_count.times do
      ds.create_item
    end

    since = ds.items.map(&:modified_at).min
    assert_equal target_count, ds.modified_since(since).count

    since = ds.items.map(&:modified_at).max + 1
    assert_equal 0, ds.modified_since(since).count
  end

  def test_items_deleted
    ds = RubyDataSync::MemoryDatasource.new

    target_count = 20

    target_count.times do
      ds.create_item
      ds.delete_item
    end

    since = ds.deleted_items.map(&:deleted_at).min
    assert_equal target_count, ds.deleted_since(since).count

    since = ds.deleted_items.map(&:deleted_at).max + 1
    assert_equal 0, ds.deleted_since(since).count
  end
end
