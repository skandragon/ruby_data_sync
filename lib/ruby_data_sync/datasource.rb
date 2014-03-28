module RubyDataSync
  class Datasource
    attr_reader :last_sync_date

    def initialize(last_sync)
      @last_sync_date = last_sync
    end

    #
    # Find the set of objects which have changed since the last sync
    # with this peer.
    #
    # Expected return format is an array of:
    # {
    #   uuid: 'object uuid',
    #   synced: Unix timestamp of last sync with this peer,
    #   modified: Unix timestamp of last modification time,
    #
    # }
    def find_changed_objects
    end

    def find_deleted_objects
    end

    def compare_remote_changeset(changeset)
    end
  end
end
