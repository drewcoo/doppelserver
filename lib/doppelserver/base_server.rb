require 'sinatra'
require 'sinatra/json'
# require File.expand_path '../../lib/doppelserver/base_server.rb', __FILE__
require_relative 'data'

module Doppelserver
  ENFORCE_PLURALS = true

  class BaseServer < Sinatra::Base
    require 'active_support' # for singularization/pluralization

    #
    # Determines if
    # word:: an input word
    # is singular.
    # Retutns truthy.
    #
    def singular?(word)
      ActiveSupport::Inflector.singularize(word) == word
    end

    #
    # If ENFORCE_PLURALS is true (default == true)
    # This enforces plural names for all collections
    # and returns 403 otherwise.
    # word:: collection name
    #
    def enforce_plural(word)
      return unless ENFORCE_PLURALS
      halt 403, 'only plural collection names allowed' if singular?(word)
    end

    #
    # Hold all of the data internally in the @@data.
    # It's the Data class, which holds a hash of data and
    # another of next keys. (???)
    #
    configure do
      @@data = Data.new
    end

    #
    # All meta-operations should happen through a /control endpoint.
    #
    # Deletes the internal data by clearing the @@data hash.
    #
    delete '/control/data' do
      @@data.clear
    end

    #
    # TODO:: Define this.
    # Maybe make it a list of collections?
    # Or all collections with all their data?
    #
    # For now, it returns a placeholder string.
    #
    get '/' do
      'here i am' # TODO: Change this.
    end

    #
    # Gets the data at:
    # endpoint:: the collection
    # id:: the instance identifier
    # Or 404s when not found.
    #
    get '/:endpoint/:id' do
      collection, id = params['endpoint'], params['id']
      enforce_plural(collection)
      halt 404 unless @@data.collection?(collection)
      result = @@data.get_value(collection, id)
      halt 404 if result.nil?
      json(result)
    end

    #
    # Returns the data at:
    # endpoint:: collection name
    # This is all of the data in that collection
    # or 404 if no endpoint.
    #
    get '/:endpoint' do
      collection = params[:endpoint]
      enforce_plural(collection)
      halt 404 unless @@data.collection?(collection)
      json(@@data.get_collection(collection))
    end

    #
    # No PUT, POST.
    # Adds data to collection:
    # endpoint:: is the name of the collection.
    # If it doesn't exist, add new collection.
    # If it does exist replaces (???) data.
    # Also 403 on no data passed.
    #
    post '/:endpoint' do
      request.body.rewind
      collection = params['endpoint']
      enforce_plural(collection)
      raw_data = request.body.read
      halt 403, 'NO DATA' if raw_data.empty?
      data = begin
               JSON.parse(raw_data)
             rescue
               halt 403, "BAD DATA:\n#{raw_data}"
             end
      json(id: @@data.add(collection, data))
    end

    #
    # No PUT, POST.
    # Add data with the id to the collection.
    # endpoint:: collection name
    # id:: unique identifier for the data
    # Adds a collection if doesn't exist.
    # Adds id and data at it if id doesn't exist.
    # Otherwise, replaces data. Unless no data, then 403.
    #
    post '/:endpoint/:id' do
      request.body.rewind
      collection, id = params['endpoint'], params['id']
      enforce_plural(collection)
      halt 403 unless @@data.collection_key?(collection, id)
      raw_data = request.body.read
      halt 403, 'NO DATA' if raw_data.empty?
      data = begin
               JSON.parse(raw_data)
             rescue
               halt 403, "BAD DATA:\n#{raw_data}"
             end
      halt 403 unless @@data.update?(collection, id, data)
    end

    #
    # Delete the data from
    # endpoint:: collection name
    # id:: with unique identifier
    # Or 404 if one of those isn't found.
    #
    delete '/:endpoint/:id' do
      request.body.rewind
      collection, id = params['endpoint'], params['id']
      enforce_plural(collection)
      halt 404 unless @@data.collection?(collection)
      if @@data.delete(collection, id)
        status 200
      else
        halt 404
      end
    end

    run! if app_file == $PROGRAM_NAME
  end
end
