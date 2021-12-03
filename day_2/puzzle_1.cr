def position
  x = 0
  z = 0
  File.read_lines(ARGV[0]).each do |movement|
    direction, distance = movement.split(" ")
    if direction == "forward"
      x += distance.to_i
    else
      modifer = direction == "up" ? -1 : 1
      z += (distance.to_i * modifer)
    end
  end
  [x, z]
end

puts position.reduce { |acc, i| acc * i } # 1561344
