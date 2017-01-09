require 'oystercard'

describe Oystercard do
  subject(:oystercard) {described_class.new }

  it 'newly initialized cards have a balance of 0' do
    expect(oystercard.balance).to eq 0
  end

  describe '#top_up' do
    it { is_expected.to respond_to(:top_up).with(1).argument }

    it 'tops up the balance with given amount' do
      expect{ oystercard.top_up 33 }.to change{ subject.balance }.by 33
    end

    it 'raises an error if maximum balance is reached' do
      oystercard.top_up(Oystercard::LIMIT)
      message = "Sorry, your new balance cannot exceed £#{Oystercard::LIMIT}"
      expect { oystercard.top_up 1}.to raise_error message
    end

  end

  describe '#deduct' do
    it { is_expected.to respond_to(:deduct).with(1).argument}

    it 'deducts given amount from the balance' do
      expect{ oystercard.deduct 17 }.to change{ oystercard.balance }.by -17
    end


  end

end
