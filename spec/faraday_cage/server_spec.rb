require 'spec_helper'

describe FaradayCage::Server do

  describe '#initialize' do

    let(:app) do
      double('Rack app')
    end

    it 'wraps the provided app in RackMiddleware' do
      expect(described_class.new(app).app).to eq(app)
    end

    context 'when there is no default app configured' do

      it 'raises an error' do
        expect { described_class.new }.to raise_error(FaradayCage::Error)
      end
    end
  end

  describe '#connection' do

    subject(:server) do
      described_class.new(double('Rack app'))
    end

    it 'returns a Faraday::Connection' do
      expect(server.connection).to be_a(Faraday::Connection)
    end

    it 'sets the URL to FaradayCage.default_host' do
      expect(server.connection.url_prefix).to eq(URI.parse(FaradayCage.default_host))
    end

    it 'uses the Rack adapter' do
      expect(server.connection.builder.handlers.first).to eq(Faraday::Adapter::Rack)
    end

    context 'when FaradayCage.middleware is set' do

      let(:middleware) do
        double('middleware')
      end

      it 'calls the stored proc with the connection' do
        FaradayCage.should_receive(:middleware).at_least(1).times.and_return(middleware)
        middleware.should_receive(:respond_to?).with(:call).and_return(true)
        middleware.should_receive(:call) { |conn| expect(conn).to be_a(Faraday::Connection) }
        server.connection
      end
    end
  end
end
