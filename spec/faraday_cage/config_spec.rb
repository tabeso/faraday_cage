require 'spec_helper'

describe FaradayCage::Config do

  describe '#initialize' do

    it 'sets the default host' do
      expect(described_class.new.default_host).to eq('http://example.com')
    end
  end

  describe '#app' do

    let(:app) do
      nil
    end

    subject(:config) do
      described_class.new.tap do |config|
        config.app = app
      end
    end

    context 'when an app is set' do

      let(:app) do
        :foo
      end

      it 'returns the set app' do
        expect(config.app).to eq(:foo)
      end
    end

    context 'when an app is not set' do

      context 'when Rails is defined' do

        it 'returns #default_rails_app' do
          stub_const('Rails', Class.new)
          config.should_receive(:default_rails_app).and_return(:bar)
          expect(config.app).to eq(:bar)
        end
      end

      context 'when Rails is not defined' do

        it 'returns nil' do
          expect(config.app).to be_nil
        end
      end
    end
  end

  describe '#middleware' do

    subject(:config) do
      described_class.new
    end

    context 'when a block is given' do

      it 'stores the provided block as a proc' do
        block = -> { 'blah blah blah' }
        config.middleware(&block)
        expect(config.middleware).to eq(block)
      end
    end
  end
end
