def unique_digit_count(input)
  parsed = input.map { |i| i.split("|").map { |s| s.strip } }
  signals = [] of String
  digits = [] of String
  parsed.each do |string_array|
    signals << string_array[0]
    digits << string_array[1]
  end
  digit_counts = digits.flat_map { |d| d.split(" ").map { |d| d.size } }.tally
  digit_counts.select(2, 3, 4, 7).sum { |_k, v| v }
end

puts unique_digit_count(File.read_lines(ARGV[0]))
