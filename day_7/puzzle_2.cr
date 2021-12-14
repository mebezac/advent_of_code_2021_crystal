def fuel_cost(input)
  crab_positions = input.split(",").map { |s| s.to_i }.tally
  fuel_costs = {} of Int32 => Int32
  positions = (crab_positions.keys.min..crab_positions.keys.max).to_a
  positions.each do |move_to|
    cost = crab_positions.sum do |position, count|
      (0..(position - move_to).abs).to_a.sum * count
    end
    fuel_costs[move_to] = cost
  end
  fuel_costs.to_a.sort_by { |k, v| v }[0]
end

puts fuel_cost(File.read(ARGV[0]))
