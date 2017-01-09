require 'oystercard'

describe Oystercard do
  subject(:oystercard) {described_class.new }

  it 'newly initialized cards have a balance of 0' do
    expect(oystercard.balance).to eq 0
  end

  describe '#top_up' do
    it { is_expected.to respond_to(:top_up).with(1).argument }

    it 'tops up the balance with given amount' do
      # oystercard.top_up(33)
      # expect(oystercard.balance).to eq 33
      expect{ oystercard.top_up 33 }.to change{ subject.balance }.by 33
    end
  end

end
