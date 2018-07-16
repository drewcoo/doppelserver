require 'spec_helper'
require File.expand_path('scc_wrapper', __dir__)

def escape_quotes(string)
  string.gsub('"', '\"')
end

RSpec.describe 'ServiceControllerConsole', :slow do
  let(:scc) do
    SCCWrapper.new
  end

  after do
    scc.stop if defined?(scc) && !scc.nil?
  end

  context 'when stopped' do
    it 'cannot #stop' do
      scc.stop
      expect(scc.stdout).to eq ''
      expect(scc.stderr).to match 'ERROR'
      expect(scc.status.to_i).not_to eq 0
    end

    it 'can #start' do
      expect(scc.start).to be true
      expect(scc.status.to_i).to eq(0)
    end

    it 'cannot #get data' do
      scc.data
      expect(scc.stdout).to eq ''
      expect(scc.stderr).to match 'ERROR'
      expect(scc.status.to_i).not_to eq 0
    end

    it 'cannot #restart' do
      expect(scc.restart).to be false
    end
  end

  context 'when started' do
    before { expect(scc.start).to be true }

    it 'can #get data' do
      scc.data
      expect(scc.status.to_i).to eq 0
      # Deal with the escaping to go to CLI and back
      expect(scc.stdout.chomp).to eq escape_quotes(DEFAULT_DATA)
    end

    it 'can #set data' do
      # first, put the data
      scc.data "-s #{escape_quotes(TEST_DATA)}"
      expect(scc.status.to_i).to eq 0
      # now get the data back . . .
      expect(scc.data).to be true
      expect(scc.stdout.chomp).to eq escape_quotes(TEST_DATA)
    end

    it 'can #restart' do
      expect(scc.restart).to be true
    end
  end
end
