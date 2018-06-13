module Doppelserver
  #
  # A glorified hash.
  #
  class Data
    #
    # Initiallizes (cleared) all internal data.
    #
    def initialize
      @data = {}
      @next_keys = {}
    end

    #
    # Clears all internal data.
    #
    def clear
      @data = {}
      @next_keys = {}
    end

    #
    # Returns the collection called parameter name.
    #
    def collection?(name)
      @data.key?(name)
    end

    #
    # Returns boolean, true if collection 1st param) exists
    # and has key (2nd param).
    #
    def collection_key?(collection, key)
      collection?(collection) && @data[collection].key?(key)
    end

    #
    # Returns collection named parameter name.
    #
    def get_collection(name)
      @data[name]
    end

    #
    # Returns the value from the collection at first parameter
    # at key of the second parameter.
    #
    def get_value(collection, key)
      @data[collection][key]
    end

    #
    # Adds the collection if that name (1st param) doesn't exist.
    # Adds data (2nd param) to the collection regardless.
    #
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

    #
    # Updates collection[id] to new data.
    #
    def update?(collection, id, data)
      data.each_key do |key|
        return false unless @data[collection][id].key?(key)
      end
      data.each do |key, value|
        @data[collection][id][key] = value
      end
      true
    end

    #
    # Deletes the data at key (2nd param) from collection (1st param).
    #
    def delete(collection, key)
      @data[collection].delete(key)
    end
  end
end
