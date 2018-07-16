require 'sinatra'
require 'sinatra/json'
require 'doppelserver/routes/helpers/capture_helper'
require 'doppelserver/routes/helpers/request_parse_helper'

module Doppelserver
  #
  # All of the REST routes for BaseServer are here.
  #
  class BaseServer < Sinatra::Base
    include CaptureHelper
    include RequestParseHelper

    #
    # Gets the data at:
    # endpoint:: the collection
    # id:: the instance identifier
    # Or 404s when not found.
    #
    get COLLECTION_AND_ID do
      collection, id = parse_params(params)
      check_exists(collection, @@data)
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
    get COLLECTION_ONLY do
      collection = parse_params(params)
      check_exists(collection, @@data)
      json(@@data.get_collection(collection))
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
    post COLLECTION_AND_ID do
      request.body.rewind
      collection, id = parse_params(params)
      halt 403 unless @@data.collection_key?(collection, id)
      data = read_post_data(request.body)
      halt 403 unless @@data.update?(collection, id, data)
    end

    #
    # No PUT, POST.
    # Adds data to collection:
    # endpoint:: is the name of the collection.
    # If it doesn't exist, add new collection.
    # If it does exist replaces (???) data.
    # Also 403 on no data passed.
    #
    post COLLECTION_ONLY do
      request.body.rewind
      collection = parse_params(params)
      data = read_post_data(request.body)
      json(id: @@data.add(collection, data))
    end

    #
    # Delete the data from
    # endpoint:: collection name
    # id:: with unique identifier
    # Or 404 if one of those isn't found.
    #
    delete COLLECTION_AND_ID do
      request.body.rewind
      collection, id = parse_params(params)
      check_exists(collection, @@data)
      if @@data.delete(collection, id)
        status 200
      else
        halt 404
      end
    end
  end
end
