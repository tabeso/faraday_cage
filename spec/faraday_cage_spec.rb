require 'spec_helper'

describe FaradayCage do

  describe '.configure' do

    it 'yields the config singleton' do
      expect { |block| FaradayCage.configure(&block) }.to yield_with_args(FaradayCage.config)
    end
  end

  describe '.config' do

    it 'returns an instance of FaradayCage::Config' do
      expect(FaradayCage.config).to be_a(FaradayCage::Config)
    end

    it 'keeps the same instance' do
      expect(FaradayCage.config.object_id).to eq(FaradayCage.config.object_id)
    end
  end

  FaradayCage::Config.public_instance_methods(false).each do |method|

    describe ".#{method}" do

      it 'delegates to .config' do
        FaradayCage.config.should_receive(method)
        FaradayCage.send(method)
      end
    end
  end
end
