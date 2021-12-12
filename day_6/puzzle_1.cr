class LanternFish
  getter timer : Int32

  def initialize(timer = 8)
    @timer = timer
  end

  def decrement_timer
    @timer -= 1
  end

  def reset_timer
    @timer = 6
  end

  def should_give_birth?
    @timer == -1
  end
end

def fish_count(input)
  initial_state = input.split(",").map { |x| x.to_i }
  fish = initial_state.map { |i| LanternFish.new(i) }
  80.times do
    new_fish_count = 0
    fish.each do |f|
      f.decrement_timer
      if f.should_give_birth?
        new_fish_count += 1
        f.reset_timer
      end
    end
    new_fish = Array.new(new_fish_count) { LanternFish.new }
    fish += new_fish
  end
  fish.size
end

puts fish_count(File.read(ARGV[0]))
