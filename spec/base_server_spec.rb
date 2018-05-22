require 'spec_helper'
ENV['RACK_ENV'] = 'test'
require 'rack/test'
require 'rspec'
require File.expand_path '../lib/doppelserver/base_server.rb', __dir__
require 'json'

# require File.expand_path '../spec_helper.rb', __FILE__
require 'spec_helper'

module RSpecMixin
  include Rack::Test::Methods
  def app() Doppelserver::BaseServer end
end
RSpec.configure { |c| c.include RSpecMixin }

describe Doppelserver::BaseServer do
  it 'something' do
    get '/'
    expect(last_response.body).to eq('here i am')
    expect(last_response.status).to eq(200)
    expect(last_response).to be_ok
  end

  context 'post to add to a collection' do
    context 'returns' do
      it '403s when no payload is passed' do
        post '/foos'
        expect(last_response.status).to eq(403)
      end

      it '403s when non-JSON is passed' do
        post '/foos', 'qwertyu'
        expect(last_response.status).to eq(403)
      end

      context 'element id' do
        before(:each) do
          delete '/control/data'
          expect(last_response.status).to eq(200)
        end

        it 'for first element added' do
          post '/foos', { name: 'first', other: 'thing' }.to_json
          expect(last_response.status).to eq(200)
          expect(JSON.parse(last_response.body)['id']).to eq('0')
        end

        it 'for last added element' do
          delete '/control/data'
          element_number = rand(10)
          (0..element_number).each do |num|
            post '/foos', { name: "name_#{num}", other: 'thing' }.to_json
          end
          expect(JSON.parse(last_response.body)['id']).to eq(element_number.to_s)
        end
      end
    end
  end

  context 'post to update an element' do
    before(:each) do
      delete '/control/data'
      expect(last_response.status).to eq(200)
      post '/things', { name: 'first', description: 'first thing' }.to_json
      post '/things', { name: 'second', description: 'second thing' }.to_json
      expect(JSON.parse(last_response.body)['id']).to eq('1')
    end

    it 'can update an existing element' do
      post '/things/1', { description: 'updated thing' }.to_json
      expect(last_response).to be_ok
      get '/things/1'
      expect(last_response).to be_ok
      data = JSON.parse(last_response.body)
      expect(data['name']).to eq('second')
      expect(data['description']).to eq('updated thing')
    end

    it 'cannot update a non-existent element' do
      post '/things/5', { name: 'foo' }.to_json
      expect(last_response.status).to eq(403)
    end
  end

  context 'put to replace an element'

  context 'get' do
    before(:each) do
      delete '/control/data'
      expect(last_response.status).to eq(200)
    end

    it 'works on existing item' do
      post '/foos', { name: 'first', other: 'thing' }.to_json
      element_id = JSON.parse(last_response.body)['id']
      get "/foos/#{element_id}"
      expect(last_response).to be_ok
      response = JSON.parse(last_response.body)
      expect(response['name']).to eq('first')
      expect(response['other']).to eq('thing')
    end

    it '404s on item that does not exist' do
      get '/foos/1000'
      expect(last_response.status).to eq(404)
    end

    it 'can return the entire collection' do
      # because we haven't implemented anything like paging
      post '/foos', { name: 'first', other: 'thing one' }.to_json
      post '/foos', { name: 'second', other: 'thing 2' }.to_json
      get '/foos'
      expect(last_response).to be_ok
      data = JSON.parse(last_response.body)
      expect(data.length).to eq(2)
      expect(data['0']['other']).to eq('thing one')
      expect(data['1']['name']).to eq('second')
    end
  end

  context 'delete' do
    before(:each) do
      delete '/control/data'
      post '/foos', { name: 'first', other: 'thing' }.to_json
      get '/foos/0'
      expect(last_response).to be_ok
    end

    it 'can remove an existing item' do
      delete '/foos/0'
      # expect(last_response).to be_ok
      expect(last_response.status).to eq(200)
      get '/foos/0'
      expect(last_response.status).to eq(404)
      get '/foos/0'
      expect(last_response.body).to eq('')
      expect(last_response.status).to eq(404)
    end

    it '404s on deletion of non-existent item' do
      delete '/foos/1'
      expect(last_response.status).to eq(404)
      get '/foos/1'
      expect(last_response.status).to eq(404)
    end

    it 'cannot remove singular item' do
      delete '/foo/0'
      expect(last_response.status).to eq(403)
    end
  end
end
