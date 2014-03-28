module RubyDataSync
  class Datasource
    attr_accessor :last_sync_date

    def initialize
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
    # }
    #
    def find_changed_objects
    end

    #
    # Find the set of objects which have deleted since the last sync
    # with this peer.
    #
    # Expected return format is an array of:
    # {
    #   uuid: 'object uuid',
    #   synced: Unix timestamp of last sync with this peer,
    #   deleted: Unix timestamp of the deletion time,
    # }
    #
    def find_deleted_objects
    end

    def compare_remote_changeset(changeset)
    end
  end
end
