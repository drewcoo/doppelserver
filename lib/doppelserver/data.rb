module Doppelserver
  class Data
    def initialize
      @data = {}
      @next_keys = {}
    end

    def clear
      @data = {}
      @next_keys = {}
    end

    def collection?(name)
      @data.key?(name)
    end

    def collection_key?(collection, key)
      collection?(collection) && @data[collection].key?(key)
    end

    def get_collection(name)
      @data[name]
    end

    def get_value(collection, key)
      @data[collection][key]
    end

    def add(collection, data)
      unless collection?(collection)
        @data[collection] = {}
        @next_keys[collection] = 0
      end
      next_key = @next_keys[collection]
      @data[collection][next_key.to_s] = data
      @next_keys[collection] += 1
      next_key.to_s
    end

    def update?(collection, id, data)
      data.each_key do |key|
        return false unless @data[collection][id].key?(key)
      end
      data.each do |key, value|
        @data[collection][id][key] = value
      end
      true
    end

    def delete(collection, key)
      @data[collection].delete(key)
    end
  end
end
