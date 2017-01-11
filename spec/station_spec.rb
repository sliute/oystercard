require 'station'

describe Station do
  subject(:station) { described_class.new('Bank', 1) }

  it 'exposes a name' do
    expect(station.name).to eq('Bank')
  end

  it 'exposes a zone' do
    expect(station.zone).to eq(1)
  end
end
