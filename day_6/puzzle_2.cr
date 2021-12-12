def fish_count(input)
  initial_state = input.split(",").map { |x| x.to_i }.tally.transform_values { |v| v.to_i64 }

  fish = {0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0, 8 => 0}.transform_values { |v| v.to_i64 }.merge(initial_state)
  256.times do |i|
    new_fish = {} of Int32 => Int64
    new_fish[7] = fish[8]
    new_fish[8] = fish[0]
    new_fish[6] = fish[0] + fish[7]
    (0..5).each do |i|
      new_fish[i] = fish[i + 1]
    end
    fish = new_fish
  end
  fish.values.sum
end

puts fish_count(File.read(ARGV[0]))
