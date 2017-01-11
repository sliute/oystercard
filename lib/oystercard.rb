class Oystercard

  LIMIT = 90
  MIN_FARE = 1
  attr_reader :balance, :entry_station, :exit_station, :journeys

  def initialize
    @balance = 0
    @journeys = []
  end

  def top_up(amount)
    raise "Sorry, your new balance cannot exceed £#{LIMIT}" if ((@balance + amount) > LIMIT)
    @balance += amount
  end

  def touch_in(station)
    raise "Insufficient funds. Please top up to a minimum of £#{Oystercard::MIN_FARE}." if @balance < MIN_FARE
    @in_journey = true
    @entry_station = station
  end

  def touch_out(station)
    deduct(MIN_FARE)
    @in_journey = false
    @exit_station = station
    @journeys << {entry_station: @entry_station, exit_station: @exit_station}
  end

  def in_journey?
    @in_journey
  end

  private
  def deduct(amount)
    @balance -= amount
  end

end
