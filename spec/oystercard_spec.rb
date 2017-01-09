require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new }
  let(:station) { double :station }

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

  describe '#touch_in' do
    it { is_expected.to respond_to(:touch_in).with(1).argument}

    it 'raises an error unless balance is at least minimum fare' do
      message = "Insufficient funds. Please top up to a minimum of £#{Oystercard::MIN_FARE}."
      expect { oystercard.touch_in(station) }.to raise_error message
    end

    # DRY the 2 tests below

    it 'changes the card status to in journey' do
      oystercard.top_up(Oystercard::MIN_FARE)
      oystercard.touch_in(station)
      expect(oystercard).to be_in_journey
    end

    it 'remembers the entry station' do
      oystercard.top_up(Oystercard::MIN_FARE)
      oystercard.touch_in(station)
      expect(oystercard.entry_station).to eq station
    end

  end

  describe '#touch_out' do
    it { is_expected.to respond_to(:touch_out)}

    it 'changes the card status to outside journey' do
      oystercard.touch_out
      expect(oystercard).not_to be_in_journey
    end

    it 'deducts minimum fare on touch out' do
      oystercard.top_up(Oystercard::MIN_FARE)
      oystercard.touch_in(station)
      expect {oystercard.touch_out}.to change {oystercard.balance}.by(-Oystercard::MIN_FARE)
    end

    it 'clears the entry station upon exit' do
      oystercard.top_up(Oystercard::MIN_FARE)
      oystercard.touch_in(station)
      oystercard.touch_out
      expect(oystercard.entry_station).to eq nil
    end

  end

  describe '#in_journey?' do
    before do
      oystercard.top_up(Oystercard::MIN_FARE)
      oystercard.touch_in(station)
    end

    it 'returns true after touch in' do
      expect(oystercard.in_journey?).to eq true
    end

    it 'returns false after touch out' do
      oystercard.touch_out
      expect(oystercard.in_journey?).to eq false
    end

  end

end
