require "bit_array"

class PowerConsumptionRating
  @bit_lists : Array(String)
  @most_common_bits : BitArray
  @least_common_bits : BitArray

  def initialize
    @bit_lists = File.read_lines(ARGV[0])
    @most_common_bits = most_common_bits
    @least_common_bits = @most_common_bits.dup
    @least_common_bits.invert
  end

  def most_common_bit_at_position(position)
    fbit, tbit = @bit_lists.partition { |bit_list| bit_list[position] == '0' }
    tbit.size > fbit.size
  end

  def most_common_bits
    ba = BitArray.new(@bit_lists.first.chars.size)
    ba.size.times do |i|
      ba[i] = most_common_bit_at_position(i)
    end
    ba
  end

  def rate
    gamma = @most_common_bits.map { |i| i ? "1" : "0" }.join("").to_i(2)
    epsilon = @least_common_bits.map { |i| i ? "1" : "0" }.join("").to_i(2)
    gamma * epsilon
  end
end

puts PowerConsumptionRating.new.rate
