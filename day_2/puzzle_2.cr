def position_with_aim
  aim = 0
  x = 0
  z = 0
  File.read_lines(ARGV[0]).each do |movement|
    direction, distance = movement.split(" ")
    distance = distance.to_i
    if direction == "forward"
      x += distance
      z += (aim * distance)
    else
      modifer = direction == "up" ? -1 : 1
      aim += (distance * modifer)
    end
  end
  [x, z]
end

puts position_with_aim.reduce { |acc, i| acc * i } # 1561344
