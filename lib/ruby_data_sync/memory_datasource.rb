module RubyDataSync

  #
  # Implementation of an in-memory data source.
  #
  class MemoryDatasource < Datasource
    class Item
      attr_accessor :data
      attr_accessor :uuid
      attr_accessor :modified_at
      attr_accessor :created_at
      attr_accessor :synced_at

      def initialize(data)
        self.data = data
        self.uuid = SecureRandom.uuid
        now = Time.now.to_f
        self.modified_at = now
        self.created_at = now
        self.synced_at = 0
      end
    end

    class DeletedItem
      attr_accessor :uuid
      attr_accessor :deleted_at

      def initialize(item)
        self.uuid = item.uuid
        self.deleted_at = Time.now.to_f
      end
    end

    attr_accessor :items
    attr_accessor :deleted_items

    def initialize
      super
      self.items = []
      self.deleted_items = []
    end

    #
    # Create an item with a random name.
    #
    def create_item
      item = Item.new({ name: SecureRandom.base64 })
      items << item
      item
    end

    #
    # Delete an item at random.  This is used for testing.
    #
    def delete_item
      if items.count > 0
        selection = rand(items.count)
        item = items.delete_at(selection)
        deleted_item = DeletedItem.new(item)
        deleted_items << deleted_item
        deleted_item
      end
    end

    #
    # Return a list of items modified locally as of a particular date.
    #
    def modified_since(since)
      items.select { |item| item.modified_at >= since }
    end

    #
    # Return a list of items which have been deleted locally as of a particular
    # date.
    #
    def deleted_since(since)
      deleted_items.select { |item| item.deleted_at >= since }
    end

    #
    # Return an array containing the items which need to be synced.  This
    # is defined as the modified_at is greater than or equal to the synced_at
    # timestamp.
    #
    def unsynced
      items.select { |item| item.synced_at < item.modified_at }
    end
  end
end
