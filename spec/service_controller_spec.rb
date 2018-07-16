require 'spec_helper'

DEFAULT_PORT = '7357'.freeze
ALTERNATE_PORT = '8080'.freeze

RSpec.describe ServiceController, :slow do
  let(:port) { DEFAULT_PORT }
  let(:sc) { ServiceController.new(port) }

  after { sc.stop }

  context 'when stopped' do
    it 'can #start' do
      sc.start
      expect(sc.port).to eq port
      expect(sc.running?).to be true
    end

    context 'when non-default port' do
      let(:port) { ALTERNATE_PORT }

      it 'can #start on a non-default port' do
        sc.start
        expect(sc.port).to eq port
        expect(sc.running?).to be true
      end
    end
  end

  context 'when started' do
    before { sc.start }

    it 'can #stop' do
      sc.stop
      expect(sc.running?).to be false
    end

    it 'can #get and #set data' do
      sc.set TEST_DATA
      expect(sc.get).to eq TEST_DATA
    end

    it 'dumps data on #restart' do
      sc.set TEST_DATA
      sc.restart
      expect(sc.get).to eq DEFAULT_DATA
    end
  end
end
