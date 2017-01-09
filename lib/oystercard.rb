class Oystercard

  LIMIT = 90
  attr_reader :balance

  def initialize
    @balance = 0
  end

  def top_up(amount)
    raise "Sorry, your new balance cannot exceed £#{LIMIT}" if ((@balance + amount) > LIMIT)
    @balance += amount
  end

end
