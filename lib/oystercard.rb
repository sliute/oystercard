class Oystercard

  LIMIT = 90
  MIN_FARE = 1
  attr_reader :balance
  attr_reader :entry_station

  def initialize
    @balance = 0
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

  def touch_out
    deduct(MIN_FARE)
    @in_journey = false
    @entry_station = nil
  end

  def in_journey?
    @entry_station == nil ? false : true
    # !!entry_station
  end

  private
  def deduct(amount)
    @balance -= amount
  end

end
