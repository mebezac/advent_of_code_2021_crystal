class BingoCard
  @rows : Array(Array(Int32))
  @columns : Array(Array(Int32))
  getter won_on : Int32

  def initialize(card_lines)
    @rows = card_lines.map { |line| line.split.map { |i| i.to_i } }
    @columns = [] of Array(Int32)
    @won_on = 100
    @rows.size.times do |i|
      @columns << @rows.map { |r| r[i] }
    end
  end

  def number_drawn(number : Int32)
    @rows.map do |r|
      if i = r.index(number)
        r[i] = 100
      end
    end

    @columns.map do |c|
      if i = c.index(number)
        c[i] = 100
      end
    end

    if has_bingo? && @won_on == 100
      @won_on = number
    end
  end

  def has_bingo?
    @rows.any? { |r| r.sum == 500 } || @columns.any? { |r| r.sum == 500 }
  end

  def sum_of_unmarked
    @rows.flat_map { |r| r.reject { |x| x == 100 } }.sum
  end
end

class SquidBingo
  def calculate(input)
    input.delete("")
    draws = input.shift.split(",").map { |d| d.to_i }
    cards = input.each_slice(5).to_a.map { |c| BingoCard.new(c) }
    while cards.any? { |c| !c.has_bingo? }
      draw = draws.shift
      cards.map { |c| c.number_drawn(draw) }
    end

    if draw && (losing_card = cards.find { |c| c.won_on == draw })
      puts losing_card.sum_of_unmarked * draw
    end
  end
end

SquidBingo.new.calculate(File.read_lines(ARGV[0]))
