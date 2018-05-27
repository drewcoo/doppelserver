require 'spec_helper'

RSpec.describe Doppelserver do
  it 'has a version number' do
    expect(Doppelserver::VERSION).not_to be nil
  end

  # it 'determines a singular word is singular' do
  #   expect(Doppelserver::BaseServer.singular?('word')).to eq(true)
  # end

  # it 'determines a plural word is not singular' do
  #   expect(Doppelserver::BaseServer.singular?('words')).to eq(false)
  # end
end
