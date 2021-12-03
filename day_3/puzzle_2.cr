require "bit_array"

class LifeSupportRating
  @bit_lists : Array(String)

  def initialize
    @bit_lists = File.read_lines(ARGV[0])
  end

  def most_common_bit_at_position(bit_lists, position)
    fbit, tbit = bit_lists.partition { |bit_list| bit_list[position] == '0' }
    tbit.size >= fbit.size
  end

  def meter_rating(type : Symbol)
    new_bit_lits = @bit_lists
    index = 0
    while new_bit_lits.size > 1
      most_common_bit = most_common_bit_at_position(new_bit_lits, index)
      most_common_bit = type == :o2 ? most_common_bit : !most_common_bit
      filter_char = most_common_bit ? '1' : '0'
      new_bit_lits = new_bit_lits.select { |bit_list| bit_list[index] == filter_char }
      index += 1
    end
    new_bit_lits[0].to_i(2)
  end

  def o2_rating
    meter_rating(:o2)
  end

  def rate
    meter_rating(:o2) * meter_rating(:co2)
  end
end

puts LifeSupportRating.new.rate
