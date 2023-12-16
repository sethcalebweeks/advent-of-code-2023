input = File.read("input").strip

alias Lens = Tuple(String, Int32)
alias Boxes = Hash(Int32, Array(Lens))

steps = input.split(',')

class String
  def hash
    self.codepoints.reduce(0) do |hash, char|
      (hash + char) * 17 % 256
    end
  end
end

part1 = steps.map(&.hash).sum

puts part1

part2 = begin
  steps = steps.map(&.split(/(-|=)/))

  boxes = (0...265).reduce(Boxes.new) do |boxes, box_num|
    boxes.merge({box_num => [] of Lens})
  end

  lenses = Set(String).new

  steps.each do |(label, op, value)|
    lenses.add(label)
    box_num = label.hash
    existing = boxes[box_num].index { |x, _| x == label }
    if op == "="
      if existing.nil?
        boxes[box_num].push({label, value.to_i})
      else
        boxes[box_num][existing] = {label, value.to_i}
      end
    else
      if !existing.nil?
        boxes[box_num].delete_at(existing)
      end
    end
  end

  lenses.reduce(0) do |sum, lens|
    box = boxes[lens.hash]
    slot = box.index { |(k, _)| k == lens }
    slot.nil? ? sum : sum + ((lens.hash + 1) * (slot + 1) * box[slot][1])
  end
end

puts part2
