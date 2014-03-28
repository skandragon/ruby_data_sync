module RubyDataSync
  class Engine
    attr_accessor :peer_uuid
    attr_reader :uuid
    attr_reader :datasource

    def initialize(options = {})
      options = {
      }.merge(options)

      raise ArgumentError.new("Must provide sync engine device uuid") unless options[:uuid]
      @uuid = options[:uuid]

      raise ArgumentError.new("Must provide a data source") unless options[:datasource]
      raise ArgumentError.new("Datasource must be a RubyDataSync::Datasource") unless options[:datasource].is_a?(RubyDataSync::Datasource)
      @datasource = options[:datasource]
    end
  end
end
