CORRECT_DIGITS = {
  0 => ['a', 'b', 'c', 'e', 'f', 'g'], #
  1 => ['c', 'f'],                     #
  2 => ['a', 'c', 'd', 'e', 'g'],      #
  3 => ['a', 'c', 'd', 'f', 'g'],      #
  4 => ['b', 'c', 'd', 'f'],           #
  5 => ['a', 'b', 'd', 'f', 'g'],      #
  6 => ['a', 'b', 'd', 'e', 'f', 'g'],
  7 => ['a', 'c', 'f'],                     #
  8 => ['a', 'b', 'c', 'd', 'e', 'f', 'g'], #
  9 => ['a', 'b', 'c', 'd', 'f', 'g'],
}

class SignalDecoder
  def initialize(@signals : Array(Array(Char)), @digits : Array(Array(Char)))
    @grouped = {} of Int32 => Array(Array(Char))
    @grouped = @signals.group_by { |s| s.size }
    @digit_chars = {} of Int32 => Array(Char)
    @string_map = {} of Char => Char
    @b_and_d = [] of Char
    get_mapping
  end

  def digit
    @digits.map do |digit|
      (@digit_chars.find { |k, v| v.sort == digit.sort } || ['w'])[0]
    end.join("").to_i
  end

  def get_mapping
    @digit_chars[1] = @grouped[2][0]
    @digit_chars[4] = @grouped[4][0]
    @digit_chars[7] = @grouped[3][0]
    @digit_chars[8] = @grouped[7][0]
    @digit_chars[9] = get_digit_9_chars
    @digit_chars[5] = get_digit_5_chars
    @digit_chars[0] = get_digit_0_chars
    @digit_chars[6] = get_digit_6_chars
    @string_map['g'] = get_string_g
    @digit_chars[3] = get_digit_3_chars
    @digit_chars[2] = get_digit_2_chars
  end

  def get_digit_5_chars
    @b_and_d = @digit_chars[4] - @digit_chars[7]
    @grouped[5].find do |chars|
      (chars & @b_and_d).size == 2
    end || [] of Char
  end

  def get_string_g
    (@digit_chars[5] - @b_and_d - @digit_chars[7])[0]
  end

  def get_digit_3_chars
    @grouped[5].find do |chars|
      (chars - @digit_chars[7] - [@string_map['g']]).size == 1
    end || [] of Char
  end

  def get_digit_2_chars
    @grouped[5].find do |chars|
      chars != @digit_chars[5] && chars != @digit_chars[3]
    end || [] of Char
  end

  def get_digit_0_chars
    @grouped[6].find do |chars|
      next if chars.sort == @digit_chars[9].sort
      (chars - @digit_chars[5]).size == 2
    end || [] of Char
  end

  def get_digit_9_chars
    eg = @digit_chars[8] - @digit_chars[1] - @digit_chars[4] - @digit_chars[7]
    @grouped[6].find do |chars|
      (chars - eg).size == 5
    end || [] of Char
  end

  def get_digit_6_chars
    @grouped[6].find do |chars|
      chars.sort != @digit_chars[0].sort && chars.sort != @digit_chars[9].sort
    end || [] of Char
  end
end

def unique_digit_count(input)
  parsed = input.map { |i| i.split('|').map { |s| s.strip.split(' ') } }
  parsed_digits = parsed.map do |string_array|
    signals = string_array[0].map { |s| s.chars }
    digits = string_array[1].map { |s| s.chars }
    SignalDecoder.new(signals, digits).digit
  end
  parsed_digits.sum
end

puts unique_digit_count(File.read_lines(ARGV[0]))
