class HeightReading
  def initialize(@column : Array(Int32), @height : Int32, @row : Array(Int32), @x : Int32, @y : Int32)
  end

  def neighbors
    left = if @x > 0
             @row[@x - 1]
           else
             10
           end
    right = if @x < (@row.size - 1)
              @row[@x + 1]
            else
              10
            end
    up = if @y > 0
           @column[@y - 1]
         else
           10
         end
    down = if @y < (@column.size - 1)
             @column[@y + 1]
           else
             10
           end
    [left, right, up, down]
  end

  def low_point?
    neighbors.min > @height
  end

  def risk_level
    @height + 1
  end
end

def risk_level_sum(input)
  rows = input.map { |s| s.split("").map { |i| i.to_i } }
  columns = rows.transpose
  height_readings = [] of HeightReading
  rows.each_with_index do |row, y|
    row.each_with_index do |height, x|
      hr = HeightReading.new(
        column: columns[x],
        height: height,
        row: rows[y],
        x: x,
        y: y
      )
      height_readings << hr
    end
  end
  height_readings.select { |hr| hr.low_point? }.sum { |hr| hr.risk_level }
end

puts risk_level_sum(File.read_lines(ARGV[0]))
