require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new }
  let(:entry_station) { double :station }
  let(:exit_station) { double :station }
  let(:journey) { {entry_station: entry_station, exit_station: exit_station} }

  describe "#initialize" do
    it 'newly initialized cards have a balance of 0' do
      expect(subject.balance).to eq 0
    end

    it 'newly initialized cards are not expected to be in journey' do
      expect(subject).not_to be_in_journey
    end

    it 'newly initialized cards start with an empty journey list' do
      expect(subject.journeys).to be_empty
    end
  end

  describe '#top_up' do
    it { is_expected.to respond_to(:top_up).with(1).argument }

    #maybe do a before block to top up the card to its limit
    it 'tops up the balance with given amount' do
      expect{ subject.top_up 33 }.to change{ subject.balance }.by 33
    end

    it 'raises an error if maximum balance is reached' do
      subject.top_up(Oystercard::LIMIT)
      message = "Sorry, your new balance cannot exceed £#{Oystercard::LIMIT}"
      expect { subject.top_up 1}.to raise_error message
    end

  end

  describe '#touch_in' do
    it { is_expected.to respond_to(:touch_in).with(1).argument}

    it 'raises an error unless balance is at least minimum fare' do
      message = "Insufficient funds. Please top up to a minimum of £#{Oystercard::MIN_FARE}."
      expect { oystercard.touch_in(entry_station) }.to raise_error message
    end

    # DRY the 2 tests below

    it 'changes the card status to in journey' do
      oystercard.top_up(Oystercard::MIN_FARE)
      oystercard.touch_in(entry_station)
      expect(oystercard).to be_in_journey
    end

    it 'remembers the entry station' do
      oystercard.top_up(Oystercard::MIN_FARE)
      oystercard.touch_in(entry_station)
      expect(oystercard.entry_station).to eq entry_station
    end

  end

  describe '#touch_out' do

    before do
      subject.top_up(Oystercard::MIN_FARE)
      subject.touch_in(entry_station)
    end

    it { is_expected.to respond_to(:touch_out).with(1).argument}

    it 'changes the card status to outside journey' do
      oystercard.touch_out(exit_station)
      expect(oystercard).not_to be_in_journey
    end

    it 'deducts minimum fare on touch out' do
      expect {subject.touch_out(exit_station)}.to change {oystercard.balance}.by(-Oystercard::MIN_FARE)
    end

    it 'remembers the exit station' do
      subject.touch_out(exit_station)
      expect(subject.exit_station).to eq exit_station
    end

    it 'stores the journey' do
      subject.touch_out(exit_station)
      expect(subject.journeys).to include journey
    end

  end

  describe '#in_journey?' do
    before do
      oystercard.top_up(Oystercard::MIN_FARE)
      oystercard.touch_in(entry_station)
    end

    it 'returns true after touch in' do
      expect(oystercard.in_journey?).to eq true
    end

    it 'returns false after touch out' do
      oystercard.touch_out(exit_station)
      expect(oystercard.in_journey?).to eq false
    end

  end

end
