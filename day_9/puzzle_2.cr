class HeightReading
  getter :height, :x, :y

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

  def lower_x_chain_left
    current_x = @x
    current_height = 0
    left_chain = [] of Array(Int32)
    while current_x > 0 && (current_height < 9)
      current_x -= 1
      current_height = @row[current_x]
      left_chain << [current_x, @y] if current_height < 9
    end
    left_chain
  end

  def lower_x_chain_right
    current_x = @x
    current_height = 0
    right_chain = [] of Array(Int32)
    while current_x < (@row.size - 1) && (current_height < 9)
      current_x += 1
      current_height = @row[current_x]
      right_chain << [current_x, @y] if current_height < 9
    end
    right_chain
  end

  def lower_x_chain
    lower_x_chain_left + [[@x, @y]] + lower_x_chain_right
  end

  def lower_y_chain_up
    current_y = @y
    current_height = 0
    left_chain = [] of Array(Int32)
    while current_y > 0 && (current_height < 9)
      current_y -= 1
      current_height = @column[current_y]
      left_chain << [@x, current_y] if current_height < 9
    end
    left_chain
  end

  def lower_y_chain_down
    current_y = @y
    current_height = 0
    right_chain = [] of Array(Int32)
    while current_y < (@column.size - 1) && (current_height < 9)
      current_y += 1
      current_height = @column[current_y]
      right_chain << [@x, current_y] if current_height < 9
    end
    right_chain
  end

  def lower_y_chain
    lower_y_chain_up + [[@x, @y]] + lower_y_chain_down
  end

  def lower_chain
    (lower_x_chain + lower_y_chain).uniq
  end

  def low_point?
    neighbors.min > @height
  end
end

class Basin
  def initialize(@columns : Array(Array(Int32)), @height : Int32, @rows : Array(Array(Int32)), @x : Int32, @y : Int32)
  end

  def cordinates
    cords = [] of Array(Int32)
    my_chain = HeightReading.new(
      column: @columns[@x],
      height: @height,
      row: @rows[@y],
      x: @x,
      y: @y
    ).lower_chain

    my_chain.flat_map do |chain_cordinate|
      chain_x = chain_cordinate[0]
      chain_y = chain_cordinate[1]
      chain_height = @rows[chain_y][chain_x]
      HeightReading.new(
        column: @columns[chain_x],
        height: chain_height,
        row: @rows[chain_y],
        x: chain_x,
        y: chain_y
      ).lower_chain
    end.uniq
  end

  def size
    cordinates.size
  end
end

def basin_output(input)
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
  low_points = height_readings.select { |hr| hr.low_point? }

  basins = low_points.map do |low_point|
    Basin.new(
      columns: columns,
      rows: rows,
      height: low_point.height,
      x: low_point.x,
      y: low_point.y,
    )
  end
  basins.sort_by { |basin| basin.size }.reverse[0..2].map { |basin| basin.size }.reduce { |acc, i| acc * i }
end

puts basin_output(File.read_lines(ARGV[0]))
