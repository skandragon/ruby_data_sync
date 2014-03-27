module RubyDataSync
  class Engine
    attr_accessor :uuid

    def initialize(options = {})
      options = {
      }.merge(options)

      raise ArgumentError.new("Must provide sync engine device uuid") unless options[:uuid]
    end
  end
end
