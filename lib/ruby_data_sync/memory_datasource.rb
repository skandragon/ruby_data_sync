module RubyDataSync

  #
  # Implementation of an in-memory data source.
  #
  class MemoryDatasource < Datasource
    class Item
      attr_accessor :name
      attr_accessor :uuid
      attr_accessor :modified_at
      attr_accessor :created_at
      attr_accessor :synced_at

      def initialize(name)
        self.name = name
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

    def create_item
      item = Item.new(SecureRandom.base64)
      items << item
    end

    def delete_item
      if items.count > 0
        selection = rand(items.count)
        item = items.delete_at(selection)
        deleted_item = DeletedItem.new(item)
        deleted_items << deleted_item
      end
    end

    def modified_since(since)
      items.select { |item| item.modified_at >= since }
    end

    def deleted_since(since)
      deleted_items.select { |item| item.deleted_at >= since }
    end
  end
end
