class Line
  getter x_range : Array(Int32), y_range : Array(Int32)

  def initialize(input)
    pair_1, pair_2 = input.split("->").map do |pair|
      pair.split(",").map { |digit| digit.to_i }
    end

    x1, x2 = [pair_1[0], pair_2[0]].sort
    y1, y2 = [pair_1[1], pair_2[1]].sort
    @x_range = (x1..x2).to_a
    @y_range = (y1..y2).to_a
  end

  def covered_points
    if @x_range.size > @y_range.size
      large_range = @x_range
      small_range = @y_range
      large_range_type = :x
    else
      large_range = @y_range
      small_range = @x_range
      large_range_type = :y
    end

    large_range.map_with_index do |large_value, i|
      small_value =
        if (i + 1) > small_range.size
          small_range[-1]
        else
          small_range[i]
        end
      large_range_type == :x ? [large_value, small_value] : [small_value, large_value]
    end
  end

  def straight_line?
    @x_range.size == 1 || @y_range.size == 1
  end
end

def overlapping_point_count(input)
  lines = input.map { |i| Line.new(i) }
  overlapping_count = 0
  points = lines.select { |l| l.straight_line? }.flat_map { |l| l.covered_points }
  points.tally.select { |_k, v| v > 1 }.size
end

puts overlapping_point_count(File.read_lines(ARGV[0]))
