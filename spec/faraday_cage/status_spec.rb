require 'spec_helper'

describe FaradayCage::Status do

  describe '#initialize' do

    it 'initializes with a status code' do
      described_class.new(200)
    end

    it 'converts the status code to an integer' do
      described_class.new('500').code.should eq(500)
    end
  end

  FaradayCage::Status::MAPPINGS.each do |code, mapping|

    describe "##{mapping}?" do

      it "returns true when #code equals #{code}" do
        described_class.new(code).should send(:"be_#{mapping}")
      end

      it "returns false when #code does not equal #{code}" do
        described_class.new(0).should_not send(:"be_#{mapping}")
      end
    end
  end

  describe '#name' do

    it 'returns the mapping for the code' do
      FaradayCage::Status::MAPPINGS.should_receive(:[]).with(5678).and_return(:foo)
      described_class.new(5678).name.should eq(:foo)
    end

    it 'caches the mapping' do
      status = described_class.new(200)
      status.name.object_id.should eq(status.name.object_id)
    end

    context 'when there is no mapping for the code' do

      it 'returns nil' do
        described_class.new(0).name.should be_nil
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
          (status == double('object', code: 404)).should be_true
        end
      end

      context 'when codes do not match' do

        it 'returns false' do
          (status == double('object', code: 444)).should be_false
        end
      end
    end

    context 'when provided object does not respond to #code' do

      context 'when object matches #code' do

        it 'returns true' do
          (status == 404).should be_true
        end
      end

      context 'when object matches #name' do

        it 'returns true' do
          (status == :not_found).should be_true
        end
      end

      context 'when object matches neither #code nor #name' do

        it 'returns false' do
          (status == nil).should be_false
        end
      end
    end
  end

  describe '#to_i' do

    it 'returns the code' do
      status = described_class.new(42)
      status.should_receive(:code).and_return(12)
      status.to_i.should eq(12)
    end
  end

  describe '#to_s' do

    it 'returns the name as a string' do
      status = described_class.new(420)
      status.should_receive(:name).and_return(:enhance_your_cool)
      status.to_s.should eq('enhance_your_cool')
    end
  end

  describe '#to_sym' do

    it 'returns the name' do
      status = described_class.new(100)
      status.should_receive(:name).and_return(:bar)
      status.to_sym.should eq(:bar)
    end
  end

  describe '#inspect' do

    subject(:inspection) do
      described_class.new(200).inspect
    end

    it 'returns a string' do
      inspection.should be_a(String)
    end

    it 'includes the class name' do
      inspection.should include('#<FaradayCage::Status')
    end

    it 'includes the status code' do
      inspection.should include('code: 200')
    end

    it 'includes the status name' do
      inspection.should include('name: :ok')
    end
  end

  describe '#type' do

    context 'when #code is between 100 and 199' do
      it 'returns :informational' do
        described_class.new(99).type.should_not eq(:informational)

        (100..199).each do |code|
          described_class.new(code).type.should eq(:informational)
        end

        described_class.new(200).type.should_not eq(:informational)
      end
    end

    context 'when #code is between 200 and 299' do

      it 'returns :success' do
        described_class.new(199).type.should_not eq(:success)

        (200..299).each do |code|
          described_class.new(code).type.should eq(:success)
        end

        described_class.new(300).type.should_not eq(:success)
      end
    end

    context 'when #code is between 300 and 399' do

      it 'returns :redirect' do
        described_class.new(299).type.should_not eq(:redirect)

        (300..399).each do |code|
          described_class.new(code).type.should eq(:redirect)
        end

        described_class.new(400).type.should_not eq(:redirect)
      end
    end

    context 'when #code is between 400 and 499' do

      it 'returns :client_error' do
        described_class.new(399).type.should_not eq(:client_error)

        (400..499).each do |code|
          described_class.new(code).type.should eq(:client_error)
        end

        described_class.new(500).type.should_not eq(:client_error)
      end
    end

    context 'when #code is between 500 and 599' do

      it 'returns :redirect' do
        described_class.new(499).type.should_not eq(:server_error)

        (500..599).each do |code|
          described_class.new(code).type.should eq(:server_error)
        end

        described_class.new(600).type.should_not eq(:server_error)
      end
    end

    context 'when #code is not between 100 and 599' do

      it 'returns :unknown' do
        (0..99).each do |code|
          described_class.new(code).type.should eq(:unknown)
        end

        (600..1000).each do |code|
          described_class.new(code).type.should eq(:unknown)
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
          status.should be_informational
        end
      end

      context 'when #type is not :informational' do

        it 'returns false' do
          status.should_receive(:type).and_return(:dreadful)
          status.should_not be_informational
        end
      end
    end

    describe '#success?' do

      context 'when #type is :success' do

        it 'returns true' do
          status.should_receive(:type).and_return(:success)
          status.should be_success
        end
      end

      context 'when #type is not :success' do

        it 'returns false' do
          status.should_receive(:type).and_return(:failure)
          status.should_not be_success
        end
      end
    end

    describe '#redirect?' do

      describe 'when #type is :redirect' do

        it 'returns true' do
          status.should_receive(:type).and_return(:redirect)
          status.should be_redirect
        end
      end

      describe 'when #type is not redirect' do

        it 'returns false' do
          status.should_receive(:type).and_return(:stay_here)
          status.should_not be_redirect
        end
      end
    end

    describe '#client_error?' do

      context 'when #type is :client_error' do

        it 'returns true' do
          status.should_receive(:type).at_least(1).times.and_return(:client_error)
          status.should be_client_error
        end
      end

      context 'when #type is not :client_error' do

        it 'returns false' do
          status.should_receive(:type).at_least(1).times.and_return(:not_an_error)
          status.should_not be_client_error
        end
      end
    end

    describe '#server_error?' do

      context 'when #type is :server_error' do

        it 'returns true' do
          status.should_receive(:type).and_return(:server_error)
          status.should be_server_error
        end
      end

      context 'when #type is not :server_error' do

        it 'returns false' do
          status.should_receive(:type).and_return(:useless)
          status.should_not be_server_error
        end
      end
    end

    describe '#error?' do

      context 'when #type is :client_error' do

        it 'returns true' do
          status.should_receive(:type).at_least(1).times.and_return(:client_error)
          status.should be_error
        end
      end

      context 'when #type is :server_error' do

        it 'returns true' do
          status.should_receive(:type).at_least(1).times.and_return(:server_error)
          status.should be_error
        end
      end

      context 'when #type is neither :client_error nor :server_error' do

        it 'returns false' do
          status.should_receive(:type).at_least(1).times.and_return(:operator_error)
          status.should_not be_error
        end
      end
    end

    describe '#unknown?' do

      context 'when #type is :unknown' do

        it 'returns true' do
          status.should_receive(:type).and_return(:unknown)
          status.should be_unknown
        end
      end

      context 'when #type is not unknown' do

        it 'returns false' do
          status.should_receive(:type).and_return(:known)
          status.should_not be_unknown
        end
      end
    end
  end
end
