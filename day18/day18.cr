input = File.read("input").strip

dig_plan = input.split("\n").map(&.split(' '))

def perimeter_vertices(instructions)
  current = {1, 1}
  perimeter = 0
  vertices = [] of typeof(current)
  instructions.each do |(direction, distance)|
    x, y = current
    distance = distance.to_i
    case direction
    when "R" then current = {x, y + distance}
    when "L" then current = {x, y - distance}
    when "U" then current = {x - distance, y}
    when "D" then current = {x + distance, y}
    else
    end
    perimeter += distance
    vertices.push(current)
  end
  {perimeter, vertices}
end

def area(vertices)
  sum = 0_f64
  (0...vertices.size - 1).each do |i|
    sum += vertices[i][0].to_f64 * vertices[i + 1][1].to_f64 / 100
    sum -= vertices[i][1].to_f64 * vertices[i + 1][0].to_f64 / 100
  end
  sum += vertices[-1][0].to_f64 * vertices[0][1].to_f64 / 100
  sum -= vertices[0][0].to_f64 * vertices[-1][1].to_f64 / 100
  sum.abs / 2_f64 * 100
end

part1 = begin
  instructions = dig_plan.map do |(direction, distance, _)|
    {direction, distance}
  end
  perimeter, vertices = perimeter_vertices(instructions)
  area = area(vertices)
  (perimeter / 2 + area + 1).round.to_i
end

puts part1

part2 = begin
  direction_map = {
    '0' => "R",
    '1' => "D",
    '2' => "L",
    '3' => "U"
  }
  instructions = dig_plan.map do |(_, _, color)|
    distance = color[2..6].to_i(16)
    direction = direction_map[color[7]]
    {direction, distance}
  end
  perimeter, vertices = perimeter_vertices(instructions)
  area = area(vertices)
  (perimeter / 2 + area + 1).round.to_i64
end

puts part2
