input = File.read("input").strip

alias Pipes = Hash(Tuple(Int32, Int32), Char)

pipes = input
  .split("\n")
  .map_with_index { |line, row| {line, row} }
  .reduce(Pipes.new) do |lines, (line, row)|
    line
      .split("")
      .map_with_index { |pipe, col| {pipe, col} }
      .reduce(Pipes.new) do |pipes, (pipe, col)|
        pipes.merge({ {row, col} => pipe })
    end.merge(lines)
end

Start = {75, 53}
Second = {75, 54}

def next_pipe(from_pos, current_pos, current_pipe)
  row = current_pos[0]
  col = current_pos[1]
  case {from_pos[0] - row, from_pos[1] - col, current_pipe}
  when {-1, 0, "L"} then {row, col + 1}
  when {-1, 0, "|"} then {row + 1, col}
  when {-1, 0, "J"} then {row, col - 1}
  when {0, 1, "F"} then {row + 1, col}
  when {0, 1, "-"} then {row, col - 1}
  when {0, 1, "L"} then {row - 1, col}
  when {1, 0, "7"} then {row, col - 1}
  when {1, 0, "|"} then {row - 1, col}
  when {1, 0, "F"} then {row, col + 1}
  when {0, -1, "J"} then {row - 1, col}
  when {0, -1, "-"} then {row, col + 1}
  when {0, -1, "7"} then {row + 1, col}  
  else {row, col}
  end
end

boundary = begin
  from = Start
  current = Second
  boundary_set = Set.new([from, current])
  while pipes[current] != "S"
    next_pipe = next_pipe(from, current, pipes[current])
    from = current
    current = next_pipe
    boundary_set.add(current)
  end
  boundary_set
end

part1 = boundary.size // 2

puts part1

part2 = pipes.keys.reduce(0) do |sum, (row, col)| 
  intersections = 0
  bend = ""
  (0..col).each do |y|
    point = {row, y}
    if boundary.includes?(point)
      case pipes[point]
      when "|"
        intersections += 1
      when "F", "L"
        bend = pipes[point]
      when "J"
        intersections += 1 if bend == "F"
        bend = ""
      when "7"
        intersections += 1 if bend == "L"
        bend = ""
      end
    end
  end
  if !boundary.includes?({row, col}) && intersections % 2 == 1
    sum + 1
  else
    sum
  end
end

puts part2
