require 'sinatra'
require 'sinatra/json'
require 'doppelserver/routes/helpers/request_parse_helper'

module Doppelserver
  #
  # The control routes for BaseServer
  #
  class BaseServer < Sinatra::Base
    include RequestParseHelper
    #
    # All meta-operations should happen through a /control endpoint.
    #
    # DELETEs the internal data by clearing the @@data hash.
    #
    delete '/control/data' do
      @@data.clear
    end

    #
    # GET all of the data.
    #
    get '/control/data' do
      json(@@data.export)
    end

    #
    # Replace all of the data.
    # GET the data, stop the service, restart the service, and POST the data
    # and we have the service in the same state as is was.
    #
    post '/control/data' do
      request.body.rewind
      @@data.hash = read_post_data(request.body)
      status 200
    end

    #
    # TODO:: Define this.
    # Maybe make it a list of collections?
    # Or all collections with all their data?
    #
    # For now, it returns a placeholder string.
    #
    get '/control' do
      json('status': 'running')
    end

    #
    # DELETE on the /control endpoint to stop the service
    # and Kernel.exit! stops immedately, skipping even at_exit stuff.
    #
    delete '/control' do
      # Save state first or count on caller to prep for the service
      # losing all data?
      exit!
    end
  end
end
