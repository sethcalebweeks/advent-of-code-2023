input = File.read("input").strip

dataset = input.split("\n").map(&.split(" ").map(&.to_i))

class Array
  
  def differences
    (1..(self.size - 1)).map do |x|
      self[x] - self[x - 1]
    end
  end

  def extrapolate(direction = 1)
    if self.uniq.size == 1
      self[0]
    else
      differences = self.differences
      if direction == 1
        self[-1] + differences.extrapolate
      else
        self[0] - differences.extrapolate(-1)
      end
    end
  end

end

part1 = dataset.map(&.extrapolate).sum
puts part1

part2 = dataset.map(&.extrapolate(-1)).sum
puts part2
