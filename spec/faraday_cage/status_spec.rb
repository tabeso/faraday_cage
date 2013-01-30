require 'spec_helper'

describe FaradayCage::Status do

  describe '#initialize' do

    it 'initializes with a status code' do
      described_class.new(200)
    end

    it 'converts the status code to an integer' do
      expect(described_class.new('500').code).to eq(500)
    end
  end

  FaradayCage::Status::MAPPINGS.each do |code, mapping|

    describe "##{mapping}?" do

      it "returns true when #code equals #{code}" do
        expect(described_class.new(code).send(:"#{mapping}?")).to be_true
      end

      it "returns false when #code does not equal #{code}" do
        expect(described_class.new(0).send(:"#{mapping}?")).to be_false
      end
    end
  end

  describe '#name' do

    it 'returns the mapping for the code' do
      FaradayCage::Status::MAPPINGS.should_receive(:[]).with(5678).and_return(:foo)
      expect(described_class.new(5678).name).to eq(:foo)
    end

    it 'caches the mapping' do
      status = described_class.new(200)
      expect(status.name.object_id).to eq(status.name.object_id)
    end

    context 'when there is no mapping for the code' do

      it 'returns nil' do
        expect(described_class.new(0).name).to be_nil
      end
    end
  end

  describe '#==' do

    subject(:status) do
      described_class.new(404)
    end

    context 'when provided object responds to #code' do

      context 'when codes match' do

        it 'returns true' do
          expect(status == double('object', code: 404)).to be_true
        end
      end

      context 'when codes do not match' do

        it 'returns false' do
          expect(status == double('object', code: 444)).to be_false
        end
      end
    end

    context 'when provided object does not respond to #code' do

      context 'when object matches #code' do

        it 'returns true' do
          expect(status == 404).to be_true
        end
      end

      context 'when object matches #name' do

        it 'returns true' do
          expect(status == :not_found).to be_true
        end
      end

      context 'when object matches neither #code nor #name' do

        it 'returns false' do
          expect(status == nil).to be_false
        end
      end
    end
  end

  describe '#to_i' do

    it 'returns the code' do
      status = described_class.new(42)
      status.should_receive(:code).and_return(12)
      expect(status.to_i).to eq(12)
    end
  end

  describe '#to_s' do

    it 'returns the name as a string' do
      status = described_class.new(420)
      status.should_receive(:name).and_return(:enhance_your_cool)
      expect(status.to_s).to eq('enhance_your_cool')
    end
  end

  describe '#to_sym' do

    it 'returns the name' do
      status = described_class.new(100)
      status.should_receive(:name).and_return(:bar)
      expect(status.to_sym).to eq(:bar)
    end
  end

  describe '#inspect' do

    subject(:inspection) do
      described_class.new(200).inspect
    end

    it 'returns a string' do
      expect(inspection).to be_a(String)
    end

    it 'includes the class name' do
      expect(inspection).to include('#<FaradayCage::Status')
    end

    it 'includes the status code' do
      expect(inspection).to include('code: 200')
    end

    it 'includes the status name' do
      expect(inspection).to include('name: :ok')
    end
  end

  describe '#type' do

    context 'when #code is between 100 and 199' do
      it 'returns :informational' do
        expect(described_class.new(99).type).to_not eq(:informational)

        (100..199).each do |code|
          expect(described_class.new(code).type).to eq(:informational)
        end

        expect(described_class.new(200).type).to_not eq(:informational)
      end
    end

    context 'when #code is between 200 and 299' do

      it 'returns :success' do
        expect(described_class.new(199).type).to_not eq(:success)

        (200..299).each do |code|
          expect(described_class.new(code).type).to eq(:success)
        end

        expect(described_class.new(300).type).to_not eq(:success)
      end
    end

    context 'when #code is between 300 and 399' do

      it 'returns :redirect' do
        expect(described_class.new(299).type).to_not eq(:redirect)

        (300..399).each do |code|
          expect(described_class.new(code).type).to eq(:redirect)
        end

        expect(described_class.new(400).type).to_not eq(:redirect)
      end
    end

    context 'when #code is between 400 and 499' do

      it 'returns :client_error' do
        expect(described_class.new(399).type).to_not eq(:client_error)

        (400..499).each do |code|
          expect(described_class.new(code).type).to eq(:client_error)
        end

        expect(described_class.new(500).type).to_not eq(:client_error)
      end
    end

    context 'when #code is between 500 and 599' do

      it 'returns :redirect' do
        expect(described_class.new(499).type).to_not eq(:server_error)

        (500..599).each do |code|
          expect(described_class.new(code).type).to eq(:server_error)
        end

        expect(described_class.new(600).type).to_not eq(:server_error)
      end
    end

    context 'when #code is not between 100 and 599' do

      it 'returns :unknown' do
        (0..99).each do |code|
          expect(described_class.new(code).type).to eq(:unknown)
        end

        (600..1000).each do |code|
          expect(described_class.new(code).type).to eq(:unknown)
        end
      end
    end
  end

  describe 'status type matchers' do

    subject(:status) do
      described_class.new(rand(0..1000))
    end

    describe '#informational?' do

      context 'when #type is :informational' do

        it 'returns true' do
          status.should_receive(:type).and_return(:informational)
          expect(status.informational?).to be_true
        end
      end

      context 'when #type is not :informational' do

        it 'returns false' do
          status.should_receive(:type).and_return(:dreadful)
          expect(status.informational?).to be_false
        end
      end
    end

    describe '#success?' do

      context 'when #type is :success' do

        it 'returns true' do
          status.should_receive(:type).and_return(:success)
          expect(status.success?).to be_true
        end
      end

      context 'when #type is not :success' do

        it 'returns false' do
          status.should_receive(:type).and_return(:failure)
          expect(status.success?).to be_false
        end
      end
    end

    describe '#redirect?' do

      describe 'when #type is :redirect' do

        it 'returns true' do
          status.should_receive(:type).and_return(:redirect)
          expect(status.redirect?).to be_true
        end
      end

      describe 'when #type is not redirect' do

        it 'returns false' do
          status.should_receive(:type).and_return(:stay_here)
          expect(status.redirect?).to be_false
        end
      end
    end

    describe '#client_error?' do

      context 'when #type is :client_error' do

        it 'returns true' do
          status.should_receive(:type).at_least(1).times.and_return(:client_error)
          expect(status.client_error?).to be_true
        end
      end

      context 'when #type is not :client_error' do

        it 'returns false' do
          status.should_receive(:type).at_least(1).times.and_return(:not_an_error)
          expect(status.client_error?).to be_false
        end
      end
    end

    describe '#server_error?' do

      context 'when #type is :server_error' do

        it 'returns true' do
          status.should_receive(:type).and_return(:server_error)
          expect(status.server_error?).to be_true
        end
      end

      context 'when #type is not :server_error' do

        it 'returns false' do
          status.should_receive(:type).and_return(:useless)
          expect(status.server_error?).to be_false
        end
      end
    end

    describe '#error?' do

      context 'when #type is :client_error' do

        it 'returns true' do
          status.should_receive(:type).at_least(1).times.and_return(:client_error)
          expect(status.error?).to be_true
        end
      end

      context 'when #type is :server_error' do

        it 'returns true' do
          status.should_receive(:type).at_least(1).times.and_return(:server_error)
          expect(status.error?).to be_true
        end
      end

      context 'when #type is neither :client_error nor :server_error' do

        it 'returns false' do
          status.should_receive(:type).at_least(1).times.and_return(:operator_error)
          expect(status.error?).to be_false
        end
      end
    end

    describe '#unknown?' do

      context 'when #type is :unknown' do

        it 'returns true' do
          status.should_receive(:type).and_return(:unknown)
          expect(status.unknown?).to be_true
        end
      end

      context 'when #type is not unknown' do

        it 'returns false' do
          status.should_receive(:type).and_return(:known)
          expect(status.unknown?).to be_false
        end
      end
    end
  end
end
