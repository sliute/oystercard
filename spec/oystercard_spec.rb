require 'oystercard'

describe Oystercard do
  subject(:oystercard) {described_class.new }

  it 'newly initialized cards have a balance of 0' do
    expect(oystercard.balance).to eq 0
  end

  it 'newly initialized cards are not expected to be in journey' do
    expect(oystercard).not_to be_in_journey
  end

  describe '#top_up' do
    it { is_expected.to respond_to(:top_up).with(1).argument }

    #maybe do a before block to top up the card to its limit 
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

  describe '#touch_in' do
    it { is_expected.to respond_to(:touch_in)}

    it 'changes the card status to in journey' do
      oystercard.touch_in
      expect(oystercard).to be_in_journey
    end

  end

  describe '#touch_out' do
    it { is_expected.to respond_to(:touch_out)}

    it 'changes the card status to outside journey' do
      oystercard.touch_out
      expect(oystercard).not_to be_in_journey
    end

  end

  describe '#in_journey?' do
    it 'returns true after touch in' do
      oystercard.touch_in
      expect(oystercard.in_journey?).to eq true
    end

    it 'returns false after touch out' do
      oystercard.touch_in
      oystercard.touch_out
      expect(oystercard.in_journey?).to eq false
    end

  end

end
