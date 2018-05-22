require 'sinatra'
require 'sinatra/json'
# require File.expand_path '../../lib/doppelserver/base_server.rb', __FILE__
require_relative 'data'

module Doppelserver
  ENFORCE_PLURALS = true

  class BaseServer < Sinatra::Base
    require 'active_support' # for singularization/pluralization
    def singular?(word)
      ActiveSupport::Inflector.singularize(word) == word
    end

    def enforce_plural(word)
      return unless ENFORCE_PLURALS
      halt 403, 'only plural collection names allowed' if singular?(word)
    end

    configure do
      @@data = Data.new
    end

    delete '/control/data' do
      @@data.clear
    end

    get '/' do
      body = 'here i am' # TODO: Change this.
    end

    get '/:endpoint/:id' do
      collection, id = params['endpoint'], params['id']
      enforce_plural(collection)
      halt 404 unless @@data.collection?(collection)
      result = @@data.get_value(collection, id)
      halt 404 if result.nil?
      json(result)
    end

    get '/:endpoint' do
      collection = params[:endpoint]
      enforce_plural(collection)
      halt 404 unless @@data.collection?(collection)
      json(@@data.get_collection(collection))
    end

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
      body = json(id: @@data.add(collection, data))
    end

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
