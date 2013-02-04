require 'spec_helper'

describe FaradayCage::RackMiddleware do

  describe '#initialize' do

    it 'initializes with the provided app' do
      expect(described_class.new(:foo).app).to eq(:foo)
    end
  end

  describe '#call' do

    let(:app) do
      ->(env) { [123, { foo: 'bar' }, ['it works!']] }
    end

    subject(:middleware) do
      described_class.new(app)
    end

    context 'when request is for /__identify__' do

      let(:env) do
        { 'PATH_INFO' => '/__identify__' }
      end

      it 'has a 200 status code' do
        expect(middleware.call(env)[0]).to eq(200)
      end

      it 'has a content type of text/plain' do
        expect(middleware.call(env)[1]).to eq({ 'Content-Type' => 'text/plain' })
      end

      it 'returns the object ID of the app' do
        expect(middleware.call(env)[2]).to eq([middleware.app.object_id.to_s])
      end
    end

    context 'when request is not for /__identify__' do

      let(:env) do
        { 'PATH_INFO' => '/something_else' }
      end

      it 'calls the app and returns the response' do
        expect(middleware.call(env)).to eq([123, { foo: 'bar' }, ['it works!']])
      end
    end
  end
end
